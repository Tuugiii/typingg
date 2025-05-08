from rest_framework import serializers
from .models import Language, TextChallenge, ChallengeAttempt

class LanguageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Language                                                                                           # аль моделиос сериализер үүсгэхийг заана
        fields = ['language_code', 'language_name', 'is_active']                                                   # ямар талбаруудыг сериализад оруулахыг заана
 
class TextChallengeSerializer(serializers.ModelSerializer):
    class Meta:
        model = TextChallenge
        fields = [
            'challenge_id',        # Сорилын ID (автомат өсдөг)
            'difficulty_level',    # Сорилын түвшин (EASY, MEDIUM, HARD)
            'language',            # Сорилын хэл (Language model-руу FK)
            'recommended_time',    # Санал болгосон хугацаа (минут)
            'content',             # Бичих ёстой текст агуулга
            'word_count',          # Нийт үгийн тоо
        ]

    # Энэ функц нь объектыг JSON болгох үед (API руу өгөгдөл явуулахдаа) өгөгдлийг өөрийн хүссэнээр өөрчилж гаргах боломж олгодог.
    def to_representation(self, instance):
        # Эхлээд default сериализацийг авч байна
        representation = super().to_representation(instance)
        
        # Language талбарыг бүх Language обьектоор бус зөвхөн хэлний кодоор харуулна
        # (жишээ нь: "language": "en")
        representation['language'] = instance.language.language_code
        
        return representation


# hereglegchiin oroldlogo buyu tuuh
class ChallengeAttemptSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)      # Нэмэлтээр user.username-ыг харуулах (бараг virtual field мэт)
    challenge_difficulty = serializers.CharField(source='challenge.difficulty_level', read_only=True)  # Нэмэлтээр challenge.difficulty_level-ыг харуулах
    language = serializers.CharField(source='challenge.language.language_name', read_only=True) #ymr hel deer shivsenee xarna

    class Meta:
        # Сериализер нь ямар модел дээр ажиллахыг зааж өгнө
        model = ChallengeAttempt
        
        # Сериализад оруулах талбаруудыг жагсааж байна
        fields = [
            'id',                    # Оролцоо ID
            'user',                  # Хэн оролцсон (FK)
            'username',              # Хэрэглэгчийн нэр (read_only)
            'challenge',             # Ямар сорилд оролцсон (FK)
            'challenge_difficulty',  # Сорилын хүндийн түвшин (read_only)
            'language',              # ymr hel deer shivsenee haruulna
            'correct_word_count',    # Зөв бичсэн үгийн тоо
            'wrong_word_count',      # Буруу бичсэн үгийн тоо
            'duration_seconds',      # Сорилд зарцуулсан хугацаа (секунд)
            'created_at',            # Бүртгэгдсэн огноо (автоматаар нэмэгдэнэ)
        ]
        
        # Зарим талбар зөвхөн уншигдах болно
        read_only_fields = ['created_at', 'user']
        # -> POST хийхэд эдгээрийг frontend-с явуулахгүй, сервер автоматаар онооно