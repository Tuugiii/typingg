from rest_framework import serializers
from .models import Language, TextChallenge, ChallengeAttempt

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

class ChallengeAttemptSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)
    challenge_difficulty = serializers.CharField(source='challenge.difficulty_level', read_only=True)
    
    class Meta:
        model = ChallengeAttempt
        fields = ['id', 'user', 'username', 'challenge', 'challenge_difficulty', 
                 'correct_word_count', 'wrong_word_count', 'duration_seconds', 'created_at']
        read_only_fields = ['created_at', 'user'] 