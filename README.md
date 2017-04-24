# Rack-Man

### Statement
We decided to create our own version of the classic game Pacman using Racket, and its libraries. The game features the classic gameplay of the original Pac-Man, with an implemented web based high score tracking. We have learned about working with larger projects like this, and gained valuable experience working with GitHub and in a team environment.

### Analysis

#### Recursion and Maps & Filters

We have used recursion to get the coordinates for the pellets generated. Since the pellets are scattered around the maze, we got a range of coordinates for the pellets which spawned pellets in a straight line. The function would then return the list of pellets to be used. We also used foldl to control Rack-Man from falling out of the map or going through walls. 

#### Object-Orientation

As of right now, we’re using set! to change all the states in the game. We plan on changing the game over to an object-oriented approach. 

#### State-Modification

We have used state-modification to keep track of what direction Rack-Man is currently traveling in. When the user decides to travel to the left, the left variable will be set to true while the other variables will be set to false.

### External Technologies

We have created a website that holds all the names, scores, and date played of each person that plays the game. This information is stored in a database on a web server. It is displayed in a way that allows players the ability to view the high score on that specific day as well as all time high score.  

We are also using external sources for the audio that is implemented into the game. This consists of beginning sound and chomp sound.

### Deliverable and Demonstration

What we have done for D Day (Demo Day):
- Rack-Man moving around in the maze
- A Ghost
- Pellets
- Total points shown
- Show off high scores on a website

### Evaluation of Results

We have completed the movement of the game, added a ghost, got the points system, and online high scores finished. 

## Architecture Diagram  
![Diagram](/architecture.png?raw=true "Diagram")  


Rack-Man features a relatively simple architecture. As displayed in the graphic, there is a main source file, which contains majority of the code. This is where the functions that control the view and handles player's input is. There is another file that holds the coordinates for the maze and the pellets. As it stands, this also includes the RSound, Racket Images libraries, and the functions from these that are required. Player's input is processed in the main source code as well. Key presses are registered and corresponding action are processed. The graph also displays an external sources block, which represents the use of externally sourced images and audio which are incorporated into the project.

Also shown is the connection to an external server that records and displays a player's score online. This process simply takes the player's name and score after the player has completed their turn and sends it to a web server. The web server takes that information and stores it in a database. Scripts on the web server takes all the information and displays it in a way for the player to be able to see online.

Lastly, the view is rendered by the main source code, using Racket Images and our external resources. The player's inputs are processed and the view is updated as necessary.

## Schedule

| Milestone Days | Description |
| --- | --- |
| First Milestone (Sun Apr 9) | - Have a controllable and interactive Pacman and ghost <br/> - Have base of sound working  |
| Second Milestone (Sun Apr 16) | - Create walls for maze and background graphics implemented <br/> - Have a good working prototype |
| Demo Day (Mon Apr 24, Wed Apr 26, or Fri Apr 28) | - Have the game working properly<br> - High scores connected to game |

## Group Responsibilities  
  
### Mohammed Nayeem @mohammednayeem  
worked on high scores, key presses (up, down, left, right), point system.
  
### Kevin Fossey @kfozz   
Kevin is team lead. I created the images for the game and found the sound from an external source. This means I worked with the RSound and Racket Images libraries and utilized these libraries to render the graphics portion of the game. Most of the logic of the game was discussed and reviewed with Mohammed but mainly implemented by me.
