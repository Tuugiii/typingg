from rest_framework import serializers
from .models import Language, TextChallenge

class LanguageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Language
        fields = ['language_code', 'language_name', 'is_active']

class TextChallengeSerializer(serializers.ModelSerializer):
    class Meta:
        model = TextChallenge
        fields = ['challenge_id', 'difficulty_level', 'language', 'recommended_time', 'content', 'word_count']
        
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation['language'] = instance.language.language_code
        return representation 