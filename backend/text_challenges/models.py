from django.db import models

# Create your models here.

class Language(models.Model):
    language_code = models.CharField(max_length=5, primary_key=True)
    language_name = models.CharField(max_length=100)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.language_name


class TextChallenge(models.Model):
    DIFFICULTY_CHOICES = [
        ('EASY', 'Easy'),
        ('MEDIUM', 'Medium'),
        ('HARD', 'Hard'),
    ]

    challenge_id = models.AutoField(primary_key=True)
    difficulty_level = models.CharField(max_length=10, choices=DIFFICULTY_CHOICES)
    language = models.ForeignKey(Language, on_delete=models.CASCADE, related_name='challenges')
    recommended_time = models.IntegerField(help_text="Recommended time in minutes")
    content = models.TextField()
    word_count = models.IntegerField()
    
    def __str__(self):
        return f"{self.language.language_code} - {self.difficulty_level} Challenge #{self.challenge_id}"
