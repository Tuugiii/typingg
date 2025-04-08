from django.contrib import admin
from .models import Language, TextChallenge

@admin.register(Language)
class LanguageAdmin(admin.ModelAdmin):
    list_display = ('language_code', 'language_name', 'is_active')
    list_filter = ('is_active',)
    search_fields = ('language_code', 'language_name')

@admin.register(TextChallenge)
class TextChallengeAdmin(admin.ModelAdmin):
    list_display = ('challenge_id', 'difficulty_level', 'language', 'recommended_time', 'word_count')
    list_filter = ('difficulty_level', 'language')
    search_fields = ('content',)
