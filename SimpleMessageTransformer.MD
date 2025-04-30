User Story: Build a Basic Message Transformer
As a new engineer,
I want to create a simple Spring Boot app that gets a message, adds the current date, and sends it elsewhere
so I can learn how Spring Boot, Apache Camel, and ActiveMQ work together.

What to Do:

This task helps you learn our core tools for handling messages. You will build a Spring Boot application. It will listen for messages on an ActiveMQ queue. It will add the current date and time to each message. Then, it will send the changed message to a different ActiveMQ queue. Use Gradle to build the app and Apache Camel to manage the message path. Make sure you write good tests for your code.

What Needs to Be True (Acceptance Criteria):

Set Up the App:

You have Java, Gradle, and ActiveMQ ready (using Docker is easy).
Start a new Spring Boot project or use a template. Include Spring Boot, ActiveMQ, and Camel.
You can build the app using ./gradlew build.
Get the Message:

The app is running and linked to ActiveMQ.
When a text message arrives in the input queue (like input.queue), the app must receive it.
Change the Message:

The app has received a message.
When the Camel path processes the message, add the current date and time to the end.
Use a clear format for the date and time (like yyyy-MM-dd HH:mm:ss). Example: "Hello" becomes "Hello 2023-10-27 10:30:00".
Send the Message:

The message has the date added.
When the Camel path finishes, the changed message must go to an output queue (like output.queue).
Use the Right Tools:

Your code must clearly show you used:
Spring Boot for starting and setting up the app.
Gradle for building and managing needed libraries.
Apache ActiveMQ for sending and receiving messages.
Apache Camel for guiding the message from one queue to the other and changing it.
Write Enough Tests:

You have written tests for your code.
When you run ./gradlew test, the test report must show at least 80% of the code lines are tested. This includes testing the part that changes the message and the message path itself.
Keep Code Clean:

The code is easy to read and follow.
It uses standard ways of writing Java and Spring Boot code.
Add notes in the code where needed to explain things.
Show What You Learned (Think About This):

After finishing, can you explain:
How Spring Boot helps start apps?
How ActiveMQ sends messages between apps?
How Apache Camel sets up message paths and changes messages?
How to write tests for Camel paths in a Spring Boot app?
Tips for You:

Start by setting up a basic Spring Boot project. start.spring.io is helpful.
You need ActiveMQ running. Using a Docker image (activemq) is simple.
Read about Apache Camel with Spring Boot. You'll create a class that extends RouteBuilder to define your message path.
First, get the message moving from one queue to the other. Then, add the date change step.
Writing tests early helps you see if things work and understand how parts connect. Look into camel-test-spring.
Don't be afraid to ask for help! We are here to support you.
