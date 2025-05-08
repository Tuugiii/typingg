from django.db import models
from django.conf import settings

# Create your models here.

class Language(models.Model):
    language_code = models.CharField(max_length=5, primary_key=True)                                               # ISO хэлний код (жишээ нь: 'en', 'mn')
    language_name = models.CharField(max_length=100)                                                               # Хэлний бүтэн нэр (жишээ нь: 'English', 'Монгол')
    is_active = models.BooleanField(default=True)                                                                  # Тухайн хэл идэвхтэй эсэхийг илтгэнэ

    def __str__(self):
        return self.language_name                                                                                  # Админ болон queryset-д нэрээрээ харагдана


class TextChallenge(models.Model):
    DIFFICULTY_CHOICES = [
        # Сорилын түвшний сонголтууд
        ('EASY', 'Easy'),
        ('MEDIUM', 'Medium'),
        ('HARD', 'Hard'),
    ]

    challenge_id = models.AutoField(primary_key=True)                                                              # Автоматаар нэмэгдэх анхны түлхүүр
    difficulty_level = models.CharField(max_length=10, choices=DIFFICULTY_CHOICES)                                 # Сорилын хүндийн түвшин (EASY, MEDIUM, HARD)
    language = models.ForeignKey(Language, on_delete=models.CASCADE, related_name='challenges')                    # Аль хэл дээрх сорил болохыг заана
    recommended_time = models.IntegerField(help_text="Recommended time in minutes")                                # Сорилын санал болгож буй хугацаа (минут)
    content = models.TextField()                                                                                   # Сорилын бичих текст агуулга
    word_count = models.IntegerField()                                                                             # Нийт хэдэн үгтэй сорил болохыг заана
    
    def __str__(self):
        return f"{self.language.language_code} - {self.difficulty_level} Challenge #{self.challenge_id}"


class ChallengeAttempt(models.Model):
    # Сорилд оролцсон хэрэглэгч
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='challenge_attempts')
    challenge = models.ForeignKey(TextChallenge, on_delete=models.CASCADE, related_name='attempts')     # Ямар сорилд орсон болох
    correct_word_count = models.IntegerField()     # Зөв бичсэн үгийн тоо
    wrong_word_count = models.IntegerField()     # Буруу бичсэн үгийн тоо
    duration_seconds = models.IntegerField()     # Сорилд зарцуулсан хугацаа (секундээр)
    created_at = models.DateTimeField(auto_now_add=True)     # Автоматаар бүртгэгдэх оролцсон огноо, цаг

    class Meta:
        ordering = ['-created_at'] # Сүүлийн оролцоо эхэндээ гарна

    def __str__(self):
        return f"{self.user.username}'s attempt on Challenge #{self.challenge.challenge_id}"
