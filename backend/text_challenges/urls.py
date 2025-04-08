from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import LanguageViewSet, TextChallengeViewSet, LanguageSummaryView, get_random_challenge

router = DefaultRouter()
router.register(r'languages', LanguageViewSet)
router.register(r'challenges', TextChallengeViewSet, basename='textchallenge')

urlpatterns = [
    path('', include(router.urls)),
    path('languages-summary/', LanguageSummaryView.as_view(), name='languages-summary'),
    path('challenge/', get_random_challenge, name='random-challenge'),
] 

# http://127.0.0.1:5000/api/text/challenge/?lang_code=en&level=medium&minutes=2