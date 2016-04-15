from django.shortcuts import render,HttpResponse
from django import forms
# Create your views here.
class UserInfo(forms.Form):
    email=forms.EmailField()
    host=forms.CharField()
    port=forms.CharField()
    mobile=forms.CharField()
def user_list(request):
    obj=UserInfo()
    if request.method=="POST":
        print "hello"
        user_input_obj=UserInfo(request.POST)
        if user_input_obj.is_valid():
            data=user_input_obj.clean()
            print data
        else:
            error_msg=user_input_obj.errors
            return render(request,"user_list.html",{"obj":user_input_obj,"errors":error_msg})

    else:
        return render(request,"user_list.html",{"obj":obj})

import json
def ajax_data(request):
    print request.POST
    return HttpResponse("ajax is ok")
def ajax_data_set(request):
    ret={"status":True,
         "error":'',}
    try:
        print request.POSTT
    except Exception,e:
        ret["status"]=False
        ret["error"]=str(e)
    return HttpResponse(json.dumps(ret))
def login(request):
    if request.method=="POST":
        if request.POST["username"]=="wis" and request.POST["pwd"]=="123":
            request.session["login_status"]=True
            return render(request,"login.html",{"username":request.POST["username"],})
        else:
            return render(request,"login.html")
    else:
        return render(request,"login.html")