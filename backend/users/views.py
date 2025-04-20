from django.shortcuts import render
from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework.decorators import api_view, permission_classes
from django.contrib.auth import get_user_model, authenticate
from rest_framework.response import Response
from django.http import JsonResponse
from rest_framework_simplejwt.tokens import RefreshToken

# Dynamically fetch the User model (either custom or default)
User = get_user_model()

# Хэрэглэгч бүртгэх
@api_view(['POST'])
@permission_classes([AllowAny])
def register_user(request):
    try:
        data = request.data
        username = data.get('username')  # Should match the field name in the Flutter request
        email = data.get('email')
        password = data.get('password')

        if not username or not email or not password:
            return Response({'error': 'Бүх талбарыг бөглөх шаардлагатай!'}, status=status.HTTP_400_BAD_REQUEST)

        if User.objects.filter(username=username).exists():
            return Response({'error': 'Энэ хэрэглэгчийн нэр аль хэдийн бүртгэгдсэн байна.'}, status=status.HTTP_400_BAD_REQUEST)

        user = User.objects.create_user(username=username, email=email, password=password)
        return Response({'message': 'Амжилттай бүртгэгдлээ!', 'username': user.username}, status=status.HTTP_201_CREATED)

    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# Нэвтрэх функц
@api_view(['POST'])
@permission_classes([AllowAny])
def login_user(request):
    email = request.data.get('email')
    password = request.data.get('password')

    if not email or not password:
        return JsonResponse({'error': 'Имэйл болон нууц үгээ оруулна уу!'}, status=400)

    try:
        user = User.objects.get(email=email)
        user = authenticate(username=user.username, password=password)
        if user:
            refresh = RefreshToken.for_user(user)
            return JsonResponse({
                'message': 'Амжилттай нэвтэрлээ!',
                'token': str(refresh.access_token),
                'user': {
                    'id': user.id,
                    'username': user.username,
                    'email': user.email
                }
            }, status=200)
        else:
            return JsonResponse({'error': 'Нууц үг буруу байна.'}, status=400)
    except User.DoesNotExist:
        return JsonResponse({'error': 'Имэйл бүртгэгдээгүй байна.'}, status=400)