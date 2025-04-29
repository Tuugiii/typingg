# from django.shortcuts import render
# from rest_framework import viewsets
# from rest_framework.decorators import api_view
# from rest_framework.response import Response
# from rest_framework.views import APIView
# from django.db.models import Q
# from .models import Language, TextChallenge
# from .serializers import LanguageSerializer, TextChallengeSerializer
# import random

# # Create your views here.

# class LanguageViewSet(viewsets.ReadOnlyModelViewSet):
#     queryset = Language.objects.filter(is_active=True)
#     serializer_class = LanguageSerializer

# class TextChallengeViewSet(viewsets.ReadOnlyModelViewSet):
#     serializer_class = TextChallengeSerializer
    
#     def get_queryset(self):
#         queryset = TextChallenge.objects.all()
        
#         difficulty = self.request.query_params.get('difficulty')
#         if difficulty:
#             queryset = queryset.filter(difficulty_level=difficulty.upper())
            
#         language = self.request.query_params.get('language')
#         if language:
#             queryset = queryset.filter(language__language_code=language)
            
#         return queryset

# class LanguageSummaryView(APIView):
#     def get(self, request):
#         languages = Language.objects.filter(is_active=True)
        
#         result = []
        
#         for lang in languages:
#             challenges = TextChallenge.objects.filter(language=lang)
            
#             levels = list(challenges.values_list('difficulty_level', flat=True).distinct())
#             formatted_levels = [level.capitalize() for level in levels]
            
#             minutes_by_level = {}
#             for level in levels:
#                 challenges_by_level = challenges.filter(difficulty_level=level)
#                 if challenges_by_level.exists():
#                     level_name = level.capitalize()
#                     unique_minutes = sorted(list(set(challenges_by_level.values_list('recommended_time', flat=True))))
#                     minutes_by_level[level_name] = unique_minutes
            
#             lang_summary = {
#                 "lang_name": lang.language_name,
#                 "lang_code": lang.language_code,
#                 "levels": formatted_levels,
#                 "minutes": minutes_by_level
#             }
            
#             result.append(lang_summary)
        
#         return Response(result)

# @api_view(['GET'])
# def get_random_challenge(request):
#     lang_code = request.query_params.get('lang_code')
#     level = request.query_params.get('level')
#     minutes = request.query_params.get('minutes')
    
#     if not lang_code or not level:
#         return Response(
#             {"error": "lang_code and level are required parameters"},
#             status=400
#         )
    
#     query = Q(language__language_code=lang_code)
#     query &= Q(difficulty_level=level.upper())
    
#     if minutes:
#         try:
#             minutes = int(minutes)
#             query &= Q(recommended_time=minutes)
#         except ValueError:
#             return Response(
#                 {"error": "minutes must be a number"},
#                 status=400
#             )
    
#     challenges = list(TextChallenge.objects.filter(query))
    
#     if not challenges:
#         return Response(
#             {"error": f"No challenges found for language '{lang_code}' with level '{level}'{f' and {minutes} minutes' if minutes else ''}"},
#             status=404
#         )
    
#     challenge = random.choice(challenges)
    
#     serializer = TextChallengeSerializer(challenge)
#     return Response(serializer.data)


from django.shortcuts import render
from rest_framework import viewsets, permissions
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.views import APIView
from django.db.models import Q
from .models import Language, TextChallenge, ChallengeAttempt
from .serializers import LanguageSerializer, TextChallengeSerializer, ChallengeAttemptSerializer
import random

# 👇 Одоо бүх CRUD үйлдлийг дэмжинэ (GET, POST, PUT, DELETE)
class LanguageViewSet(viewsets.ModelViewSet):
    queryset = Language.objects.filter(is_active=True)     # Зөвхөн идэвхтэй хэлнүүдийг харуулна
    serializer_class = LanguageSerializer      # Хариу өгөгдлийг сериализад хийхэд энэ сериализерыг ашиглана

class TextChallengeViewSet(viewsets.ModelViewSet):
    serializer_class = TextChallengeSerializer

    def get_queryset(self):
        queryset = TextChallenge.objects.all()         # Бүх сорилуудыг эхлээд авна
        difficulty = self.request.query_params.get('difficulty')         # Хэрэв query параметрт level байвал шүүнэ
        if difficulty:
            queryset = queryset.filter(difficulty_level=difficulty.upper())
        language = self.request.query_params.get('language')          # Хэрэв query параметрт language байвал шүүнэ
        if language:
            queryset = queryset.filter(language__language_code=language)
        return queryset

# Хэл бүр дээр хэдэн сорил, ямар түвшин, ямар хугацаатай сорил байгааг харуулна
class LanguageSummaryView(APIView):
    def get(self, request):
        languages = Language.objects.filter(is_active=True)         # Идэвхтэй бүх хэлнүүдийг авна
        result = []

        for lang in languages:
            challenges = TextChallenge.objects.filter(language=lang)
            levels = list(challenges.values_list('difficulty_level', flat=True).distinct())    # Ямар difficulty түвшин байгаа болохыг олно (давтагдаагүй)
            formatted_levels = [level.capitalize() for level in levels]
            minutes_by_level = {}             # Түвшин бүрээр хэдэн минутын сорилууд байгааг ялгаж хадгална
            for level in levels:
                challenges_by_level = challenges.filter(difficulty_level=level)
                if challenges_by_level.exists():
                    level_name = level.capitalize()
                    unique_minutes = sorted(list(set(challenges_by_level.values_list('recommended_time', flat=True))))
                    minutes_by_level[level_name] = unique_minutes

            lang_summary = {
                "lang_name": lang.language_name,
                "lang_code": lang.language_code,
                "levels": formatted_levels,
                "minutes": minutes_by_level
            }
            result.append(lang_summary)

        return Response(result)

# Санамсаргүй даалгавар буцаах API
@api_view(['GET'])
def get_random_challenge(request):
    lang_code = request.query_params.get('lang_code')
    level = request.query_params.get('level')
    minutes = request.query_params.get('minutes')

    if not lang_code or not level:
        return Response(
            {"error": "lang_code and level are required parameters"},
            status=400
        )

    query = Q(language__language_code=lang_code)
    query &= Q(difficulty_level=level.upper())

    if minutes:
        try:
            minutes = int(minutes)
            query &= Q(recommended_time=minutes)
        except ValueError:
            return Response(
                {"error": "minutes must be a number"},
                status=400
            )

    challenges = list(TextChallenge.objects.filter(query))

    if not challenges:
        return Response(
            {"error": f"No challenges found for language '{lang_code}' with level '{level}'{f' and {minutes} minutes' if minutes else ''}"},
            status=404
        )

    challenge = random.choice(challenges)     # Олдсон сорилуудаас нэгийг санамсаргүй сонгоно
    serializer = TextChallengeSerializer(challenge)     # Сериализад хийгээд буцаана
    return Response(serializer.data)


# Хэрэглэгч сорилд оролцсон түүхийг CRUD хэлбэрээр удирдана
class ChallengeAttemptViewSet(viewsets.ModelViewSet):
    serializer_class = ChallengeAttemptSerializer
    permission_classes = [permissions.IsAuthenticated]     # Нэвтэрсэн хэрэглэгчдэд л зөвшөөрнө

    # Зөвхөн тухайн хэрэглэгчийн оролцоо л харагдана
    def get_queryset(self):
        return ChallengeAttempt.objects.filter(user=self.request.user)

    # POST хийхэд user-ийг автоматаар онооно
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
