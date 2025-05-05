# auctionapp/views.py
from django.shortcuts import render, redirect
from .forms import SignUpForm
from django.contrib import messages
from django.contrib.auth import authenticate, login
from django.contrib.auth import logout

def index(request):
    return render(request, 'auctionapp/index.html')

def sign_up(request):
    if request.method == 'POST':
        form = SignUpForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, "Account created successfully! Please log in.")
            # return redirect('login')
    else:
        form = SignUpForm()

    return render(request, 'auctionapp/signup.html', {'form': form})


def login_user(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]

        # Authenticate user
        user = authenticate(request, username=username, password=password)
        if user is not None:
            # Log the user in
            login(request, user)
            messages.success(request, f"Welcome, {username}!")
            return redirect("index")  # Redirect to the homepage after successful login
        else:
            messages.error(request, "Invalid username or password.")
            # Return to login page with error message
            return render(request, "auctionapp/login.html")
    return render(request, "auctionapp/login.html")

def logout_user(request):
    logout(request)  # This will log out the user
    return redirect('index') 