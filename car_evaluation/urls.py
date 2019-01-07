"""djangopro URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.11/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.contrib.staticfiles.urls import staticfiles_urlpatterns
from django.conf.urls import url, include
from django.contrib import admin
from car_chezhiwang import views
from data_mining import views as view_mini

urlpatterns = [
    url(r'^admin/', admin.site.urls),
#     url(r'^car_chezhiwang/', include('car_chezhiwang.urls')),
    url(r'^index/$', views.index, name='index'),
    url(r'^dataindex/$', views.dataindex, name='dataindex'),
    url(r'^risk_page/$', views.risk_page, name='risk_page'),
    
#     url(r'^car_overweight/$', include('car_overweight.urls')),
    url(r'^car_overweight_page/$', views.car_overweight_page, name='car_overweight_page'),
    url(r'^car_overweight_index/$', views.car_overweight_index, name='car_overweight_index'),

    url(r'^files_ana_page/$', views.files_ana_page, name='files_ana_page'),
    url(r'^files_conn_page/$', views.files_conn_page, name='files_conn_page'),
    
    url(r'^association_ana_page/$', views.association_ana_page, name='association_ana_page'),

    url(r'test_list/', views.test_list, name='test_list'),

    url(r'mysql_info/', view_mini.mysql_info, name='mysql_info'),
    url(r'dict_calc/', view_mini.calculation.dict_calc, name='dict_calc'),

    url(r'data_manage/',view_mini.model_build.data_manage),
    url(r'model_save/', view_mini.model_build.model_save),
    url(r'model_list/', view_mini.model_manage.model_list),
    url(r'model_use/', view_mini.model_manage.model_use),



    
]

# urlpatterns += staticfiles_urlpatterns()