# Rack-Man

### Statement
We have decided to create our own version of the classic game Pacman using Racket, and its libraries. The game will feature the classic gameplay of the original, with implemented web based high score tracking. We hope to learn about project organization, as well as experience working on a team based assignment. In addition, we hope to gain experience with utilizing libraries and external resources.

### Analysis

#### Recursion and Maps & Filters

We plan on using recursion to get the game universe to be generated. Since the game is constantly being updated this will be the perfect place to use a recursive function. We also plan on using recursion to process user inputs like up, down, left, right.

#### Object-Orientation

We plan on using an object orientated approach in this project. Since we’re creating a game, we’ll be using making the Rack-Man an object as well as the ghosts.

#### State-Modification

We plan on using some sort of state-modification to track when the Rack-Man eats one of the power pellets to have the ghosts turn into a blue ghost which can be eaten.

### External Technologies
We plan on creating a website that holds all the names and scores of each person that plays the game. This information will be stored in a database on a web server. It will be displayed in a way that allows users the ability to view the high score on that specific day as well as all time high score.  

We will also be adding sound to our game by using a given library.

### Deliverable and Demonstration
What we plan on having for D Day (Demo Day):
- Rack-Man moving around in maze
- Ghosts
- Power pellets
- Total points shown
- Show off high scores on a website

### Evaluation of Results
If we are able to complete the movement of the game, add ghosts, and get the points system working then this will be a sucessful game. 

## Architecture Diagram
![GitHub Image](architecture.png?raw=true "Diagram")

Rack-Man will have a relatively simple architecture. As displayed in the graphic, there will be a main source file, which will contain majority of the code. This is where the functions that control the view and handle user input will be placed. As it stands, this will also include the RSound and Racket Images libraries, and the functions from these that will be required.
User input will be processed in the main source code as well. Key presses and mouse clicks will be registered and corresponding action will be processed. The graph also displays an external sources block, which represents the use of externally sourced images and audio which will be incorporated into the project.

Also shown is the connection to an external server to record and display a user’s scores online. This process will simply take the user’s name and score after the player has completed their turn and send it to a web server. The web server will then take that information and store it in a database. Scripts on the web server will then take all the information and display it in a way for the user to be able to see online. 

Lastly, the view will be rendered by the main source code, using Racket Images and our external resources. The user’s inputs will be processed and the view will be updated as necessary.

## Schedule

| Milestone Days | Description |
| --- | --- |
| First Milestone (Sun Apr 9) | - Have a controlable and interactive pacman and ghost <br/> - Have base of sound working  |
| Second Milestone (Sun Apr 16) | - Create walls for maze and background graphics implemented <br/> - Have a good working prototype |
| Demo Day (Mon Apr 24, Wed Apr 26, or Fri Apr 28) | Have the game working properly and high scores connected to game |

## Group Responsibilities
Here each group member gets a section where they, as an individual, detail what they are responsible for in this project. Each group member writes their own Responsibility section. Include the milestones and final deliverable.

Please use Github properly: each individual must make the edits to this file representing their own section of work.

**Additional instructions for teams of three:** 
* Remember that you must have prior written permission to work in groups of three (specifically, an approved `FP3` team declaration submission).
* The team must nominate a lead. This person is primarily responsible for code integration. This work may be shared, but the team lead has default responsibility.
* The team lead has full partner implementation responsibilities also.
* Identify who is team lead.

In the headings below, replace the silly names and GitHub handles with your actual ones.

### Mohammed Nayeem @mohammednayeem
will work on high scores, key presses (up, down, left, right), point system.<br/>
I plan on having a working prototype done when by April 9th.

### Kevin Fossey @kfozz 
Kevin is team lead. Additionally, Kevin will work on...   
