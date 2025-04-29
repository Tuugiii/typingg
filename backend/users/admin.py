from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import CustomUser

@admin.register(CustomUser)
class CustomUserAdmin(UserAdmin):
    list_display = ('username', 'email', 'first_name', 'last_name', 'is_staff') #Хэрэглэгчийн жагсаалтад ямар баганууд харуулахыг заана
    search_fields = ('username', 'first_name', 'last_name', 'email')
    
    # Simplified fieldsets without groups and tokens 
    #Хэрэглэгчийн дэлгэрэнгүйг засах үед бүлэглэж үзүүлнэ
    fieldsets = (
        (None, {'fields': ('username', 'password')}),
        ('Personal info', {'fields': ('first_name', 'last_name', 'email')}),
        ('Status', {'fields': ('is_active', 'is_staff', 'is_superuser')}),
    )
    
    # Simplified add form
    #Шинэ хэрэглэгч нэмэх үед ямар форм харагдахыг тодорхойлно
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'email', 'password1', 'password2', 'first_name', 'last_name'),
        }),
    )
