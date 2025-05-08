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

# Одоо бүх CRUD үйлдлийг дэмжинэ (GET, POST, PUT, DELETE)
class LanguageViewSet(viewsets.ModelViewSet):
    queryset = Language.objects.filter(is_active=True)                                                            # Зөвхөн идэвхтэй хэлнүүдийг харуулна
    serializer_class = LanguageSerializer                                                                         # serializer_class: өгөгдлийг JSON болгож буцаах сериализер

class TextChallengeViewSet(viewsets.ModelViewSet):
    serializer_class = TextChallengeSerializer

    def get_queryset(self):
        queryset = TextChallenge.objects.all()         # Бүх сорилуудыг эхлээд авна
        difficulty = self.request.query_params.get('difficulty')         # query параметраар difficulty ирсэн бол шүүнэ (жишээ нь: easy, medium)
        if difficulty:
            queryset = queryset.filter(difficulty_level=difficulty.upper())
        language = self.request.query_params.get('language')            # query параметраар хэлний код ирсэн бол тухайн хэлтэй сорилуудыг шүүнэ
        if language:
            queryset = queryset.filter(language__language_code=language)
        return queryset

# == Хэл бүр дээр ямар төвшний, ямар хугацааны сорилууд байгааг харуулна ==
class LanguageSummaryView(APIView):
    def get(self, request):
        languages = Language.objects.filter(is_active=True)                                                       # Идэвхтэй бүх хэлнүүдийг авна
        result = []

        for lang in languages:
            challenges = TextChallenge.objects.filter(language=lang)
            levels = list(challenges.values_list('difficulty_level', flat=True).distinct())                                 # Төвшнүүдийг (easy, medium, hard) давтагдаагүйгээр гаргана
            formatted_levels = [level.capitalize() for level in levels]                                          # Төвшнүүдийг format хийнэ (EASY -> Easy гэх мэт)
            
            minutes_by_level = {}             # Төвшин бүр дээр хэдэн минутын сорилууд байгааг хадгална
            for level in levels:
                challenges_by_level = challenges.filter(difficulty_level=level)   # Тухайн төвшний сорилуудыг шүүнэ
                if challenges_by_level.exists():
                    level_name = level.capitalize()
                    unique_minutes = sorted(list(set(challenges_by_level.values_list('recommended_time', flat=True))))   # Давтагдахгүй recommended_time (минут)-үүдийг олно
                    minutes_by_level[level_name] = unique_minutes                                           # тухайн төвшинд харгалзах хугацаануудыг хадгална
 # helni medeellig neg dict blgj bucaah listd nemn
            lang_summary = {
                "lang_name": lang.language_name,
                "lang_code": lang.language_code,
                "levels": formatted_levels,
                "minutes": minutes_by_level
            }
            result.append(lang_summary)

        return Response(result)  # Бүх хэлний мэдээллийг JSON хэлбэрээр буцаана

# Санамсаргүй даалгавар буцаах API
@api_view(['GET'])
def get_random_challenge(request):    # Query параметраас хэлний код болон төвшинг авна
    lang_code = request.query_params.get('lang_code')
    level = request.query_params.get('level')
    minutes = request.query_params.get('minutes')

    if not lang_code or not level:  # lang_code ба level заавал байх ёстой
        return Response(
            {"error": "lang_code and level are required parameters"},
            status=400
        )

    query = Q(language__language_code=lang_code)                                              # Q object ашиглаж шүүлт хийх query-гаа байгуулна
    query &= Q(difficulty_level=level.upper())

    if minutes:                                                                                  # Хэрвээ минут өгөгдсөн бол integer болгоод query-д нэмнэ
        try:
            minutes = int(minutes)
            query &= Q(recommended_time=minutes)
        except ValueError:
            return Response(
                {"error": "minutes must be a number"},
                status=400
            )

    challenges = list(TextChallenge.objects.filter(query))    # Бүх тохирох сорилуудыг авна

    if not challenges:    # Хэрвээ тохирох сорил байхгүй бол error буцаана
        return Response(
            {"error": f"No challenges found for language '{lang_code}' with level '{level}'{f' and {minutes} minutes' if minutes else ''}"},
            status=404
        )

    challenge = random.choice(challenges)    # Тохирох сорилуудаас нэгийг санамсаргүй сонгоно
    serializer = TextChallengeSerializer(challenge)     # Сериализад хийгээд json hlbereer буцаана
    return Response(serializer.data)


# hereglegch sorild orolcson tuuh
class ChallengeAttemptViewSet(viewsets.ModelViewSet):
    serializer_class = ChallengeAttemptSerializer
    permission_classes = [permissions.IsAuthenticated]     # Нэвтэрсэн хэрэглэгчдэд л зөвшөөрнө

    # Зөвхөн тухайн хэрэглэгчийн оролцсон түүхийг харуулна
    def get_queryset(self):
        return ChallengeAttempt.objects.filter(user=self.request.user)

    # POST хийхэд user-ийг автоматаар онооно # Шинээр оролцоо нэмэхэд тухайн хэрэглэгчийг автоматаар онооно
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
