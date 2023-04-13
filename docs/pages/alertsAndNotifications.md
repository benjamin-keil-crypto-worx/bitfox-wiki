## Alert & Notification Setup

Currently, there are 3 Different types of Notification mechanisms that you can receive Alerts from your Alerting and Notification Solutions.

1. Email
2. Slack
3. Telegram

Each of which have slightly different Setup and Configuration requirements that you need to follow very carefully in order to receive Alerts!

### Email

We are using SendGrid to send emails, so in order for you to send Emails to a dedicated Email Account you must first create a free or paid Account.

Visit this link: https://sendgrid.com/ to follow the Account Setup Instructions and optain an API Key,
you need to provide this key when you start your Alerting Bot.

As a side note, its important that after you have created an Account and generated an API Key that you also create a verified sender email address we found
this link useful and helpful: https://app.sendgrid.com/settings/sender_auth/senders

### Slack

In Order to for to leverage Slack Notifications you need to the following ready to hand:

1. A Slack Account and a Work Space
2. A Bot User that you need to configure in order to retrieve an oAuth token to make API request!

To Sign in or Create an Account got to https://slack.com

Here is a Good Guide on how to Generate a Slack Bot User you can skip the (Making Your First Request) section
Since BitFox will handle that for you!
This is a good place to learn and start setting up a Slack Account & Channel!

https://thecodebarbarian.com/working-with-the-slack-api-in-node-js.html

### Telegram
In Order to for to leverage Telegram Notifications you need to go through a few simple steps

1. Create a Bot with Bot Father
2. Take Note of the API token
3. Retrieve your session or Chat ID.

To Create a Bot with BotFather visit this link:https://blog.devgenius.io/how-to-set-up-your-telegram-bot-using-botfather-fd1896d68c02

Follow the Instructions and once you have created a bot all you need to do, is start your alerting bot with BitFox,
and open your newly created Bot on Telegram and enter ``/start`` In the chat box.

This will Create an internal Chat ID on the Bot side and the bot will start sending Notifications to your Chat!

