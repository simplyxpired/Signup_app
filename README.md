In-Class Activity  - Signup Form

Track: Undergraduate
Task: Task A - AI Signup Coach

## What I Did

I added the AI Signup Coach part to the signup form. I used the mock option since there wasn't an AI link provided. I also added a loading circle, an error message, and a retry button.

## Testing

I tested the signup form by leaving the fields empty, putting in an email without an @ symbol, and entering a password that was too short. All three showed the correct error messages. I also entered valid information and got the green success message.

For the AI part, I pressed the signup tip button and it showed the loading circle before giving the password tip. I also tested the error option and retry button, and both worked.

## Reflection Questions

1. Trace the AI tip feature from button tap to displayed text. Which widget/state changes while the request is waiting, and how does the user recover if it fails?

When I press the signup tip button, the loading circle shows up while it gets the response. After that, it shows the password tip. If there's an error, it shows a message and a retry button so I can try again.

2. Why must the app keep form validation local even when it can ask an AI for a tip?

The form needs to check the information itself because the AI is just supposed to give tips. It checks if the email has an @ symbol and if the password is at least 6 characters. This way, the AI isn't deciding if the signup information is correct.

## AI Feature

I used a mock response instead of a real AI connection. It follows the signup_tip and password_help example from the instructions, but doesn't actually send a request. It also doesn't send any names, emails, or passwords.

## What I Learned

I learned how to add a feature that shows a response after pressing a button. I also got more practice with loading indicators and showing errors when something doesn't work.