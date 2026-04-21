from flask import Flask, render_template, request, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime, timedelta
from sqlalchemy import func

app = Flask(__name__)
app.config['SECRET_KEY'] = 'mooddiary_secret_key_2024'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///mooddiary.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Diary(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    mood = db.Column(db.String(20), nullable=False)
    note = db.Column(db.String(500), nullable=False)
    date = db.Column(db.Date, nullable=False, default=datetime.now().date)
    created_at = db.Column(db.DateTime, default=datetime.now)
    updated_at = db.Column(db.DateTime, default=datetime.now, onupdate=datetime.now)

    def __repr__(self):
        return f'<Diary {self.date} {self.mood}>'

with app.app_context():
    db.create_all()

MOOD_LABELS = {
    'happy': '开心',
    'normal': '一般',
    'sad': '低落'
}

MOOD_COLORS = {
    'happy': '#22c55e',
    'normal': '#f59e0b',
    'sad': '#ef4444'
}

def get_mood_stats(start_date, end_date):
    stats = db.session.query(
        Diary.mood,
        func.count(Diary.id).label('count')
    ).filter(
        Diary.date >= start_date,
        Diary.date <= end_date
    ).group_by(Diary.mood).all()
    
    result = {'happy': 0, 'normal': 0, 'sad': 0}
    for mood, count in stats:
        result[mood] = count
    return result

@app.route('/')
def index():
    sort = request.args.get('sort', 'desc')
    start_date = request.args.get('start_date', '')
    end_date = request.args.get('end_date', '')
    
    query = Diary.query
    
    if start_date and end_date:
        try:
            start = datetime.strptime(start_date, '%Y-%m-%d').date()
            end = datetime.strptime(end_date, '%Y-%m-%d').date()
            query = query.filter(Diary.date >= start, Diary.date <= end)
        except ValueError:
            pass
    
    if sort == 'asc':
        diaries = query.order_by(Diary.date.asc()).all()
    else:
        diaries = query.order_by(Diary.date.desc()).all()
    
    today = datetime.now().date()
    week_start = today - timedelta(days=today.weekday())
    week_end = week_start + timedelta(days=6)
    week_stats = get_mood_stats(week_start, week_end)
    
    month_start = today.replace(day=1)
    if today.month == 12:
        month_end = today.replace(year=today.year+1, month=1, day=1) - timedelta(days=1)
    else:
        month_end = today.replace(month=today.month+1, day=1) - timedelta(days=1)
    month_stats = get_mood_stats(month_start, month_end)
    
    return render_template('index.html', 
                         diaries=diaries, 
                         sort=sort,
                         start_date=start_date,
                         end_date=end_date,
                         week_stats=week_stats,
                         month_stats=month_stats,
                         MOOD_LABELS=MOOD_LABELS,
                         MOOD_COLORS=MOOD_COLORS)

@app.route('/add', methods=['GET', 'POST'])
def add_diary():
    if request.method == 'POST':
        mood = request.form['mood']
        note = request.form['note']
        date_str = request.form['date']
        
        try:
            date = datetime.strptime(date_str, '%Y-%m-%d').date()
        except ValueError:
            date = datetime.now().date()
        
        diary = Diary(mood=mood, note=note, date=date)
        db.session.add(diary)
        db.session.commit()
        flash('日记添加成功！', 'success')
        return redirect(url_for('index'))
    
    today = datetime.now().strftime('%Y-%m-%d')
    return render_template('form.html', today=today, diary=None)

@app.route('/edit/<int:id>', methods=['GET', 'POST'])
def edit_diary(id):
    diary = Diary.query.get_or_404(id)
    
    if request.method == 'POST':
        diary.mood = request.form['mood']
        diary.note = request.form['note']
        date_str = request.form['date']
        
        try:
            diary.date = datetime.strptime(date_str, '%Y-%m-%d').date()
        except ValueError:
            pass
        
        db.session.commit()
        flash('日记更新成功！', 'success')
        return redirect(url_for('index'))
    
    return render_template('form.html', diary=diary, today=diary.date.strftime('%Y-%m-%d'))

@app.route('/delete/<int:id>')
def delete_diary(id):
    diary = Diary.query.get_or_404(id)
    db.session.delete(diary)
    db.session.commit()
    flash('日记已删除！', 'info')
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)
