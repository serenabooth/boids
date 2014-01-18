boids
=====

Implementation of the boids flocking algorithm in OCaml. 

`*** The Boids *** 

This is an implentation of the "Boids" flocking algorithm, first published by Craig Reynolds in the 1987 ACM SIGGRAPH journal. We used object-oriented Ocaml and a set of openGL bindings to implement our version. `

*** Running the Project ***

  Our code is dependent on the Lablgl package. This should be installed prior to attempting compilation. We have verifed that this procedure works on both Windows and Macintosh computers. The user should ideally have "make" (from the freely available minGW) added to their PATH environment variable on Windows as well (on Mac, the same is accomplished by installing Xcode and the associated Unix command-line tools).

  For your convenience we have bundled the latest version of Lablgl for Windows with the flocking program (see the "dependencies" folder). It is found in lablgl-1.04-win32.zip. We have also included the latest Lablgl source, although the authors of this project were not able to get it to build on Macintosh computers. Instead, we were able to install Lablgl and the included LablGLUT working on OSX 10.8 via the package manager Fink; once Fink is installed and configured to index unstable packages, running "fink install ocaml" and "fink install lablgl" will make compilation of the project possible.

  On Windows machines, the contents of the Win32-lablgl archive should simply be extracted directly over the Ocaml installation directory - if Windows gives you requests to merge folders when you extract the zip file, congratulations, you got the target right (agree to these merge requests). Then ensure that all of the folders in your Ocaml installation are in your PATH environment variable, and you should be off to the races. To check, try running "lablglut planet.ml" from the command line in the /examples/LablGlut folder. If you see a planet, perfect; if not, your environment variables need to be adjusted or your installation of Lablgl was unsuccessful.

  Once this is working, simply run "make" in the same directory as our project's files. It will generate "ocamlboids.exe", on which you should double click in order to see boids. In the unlikely case that "make" is unavailable, the sequence of calls to Ocamlc that eventually generate ocamlboids is included in "manual compilation instructions.txt" under /dependencies.

*** Operating the Simulation ***

  Once the code is compiled, running ocamlboids should produce two windows - a small shell window listing the keyboard/mouse controls and their functions, and a large, blank Lablglut window. From here, the user can:

 Spawn boids at random by pressing or holding the '+' key, and remove them by pressing or holding the '-' key. The boids will be initialized at random positions with (small) random velocities, and they will rapidly gather together into coherent flocks.

 By left-clicking at any location in the World, the user can spawn a few "breadcrumbs" for the boids to eat. Note that the boids will be attracted to the breadcrumbs, but only when the breadcrumbs are within the boids "sensing radius" for food.

 By right-clicking at any location in the World, the user can spawn an Obstacle at the location of the mouse pointer. These gray boxes will divert any boids who get suffciently close, and boids will also avoid them if possible. Pressing or holding `R' will remove these boxes.

 If the user would like to spawn a keyboard-controllable Predator, they can do so by pressing 'P', a toggle which spawns a stationary Predator (a large, red chevron) at a random location. Pressing 'P' again will remove the Predator from the world. This object is steered with the WASD keys, and if the user is able to bring the predator
sufficiently close to a boid, the predator will then "eat" the boid. In practice, this is reasonably challenging to achieve. :)

 In order to interact more directly with the flocking algorithm, the user can also spawn a "puppet boid" by pressing 'H'. The puppet boid is identical in appearance to an ordinary boid except for its yellow color, and although it is user-controlled, the computer-controlled boids will interact with it as if it were a computer-controlled boid. Since only one movable object may exist in the world at once, if a Predator already exists, pressing 'H' will first remove the predator, while pressing it again will spawn the puppet boid. Pressing 'H' a third time will remove the puppet boid from the World. Like the Predator, the puppet boid is steered with the WASD keys. Note that the puppet boid's maximum speed is slightly higher than that of ordinary boids, in order to facilitate the boid easily "catching up" with existing flocks.
