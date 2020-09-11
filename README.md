# NeuralNet

This project trains a neural network to play the game Snake. The neural network and game are written from the ground up in Swift without any additional libraries. This project was originally written in Objective-C, then rewritten in Swift.

## The Network
This project uses a feed-forward neural network with 24 input neurons, two hidden layers of 16 neurons, and an output layer of four neurons representing each possible move. The networks are trained using a genetic algorithm with generations of 1000 networks each. Fitness is calculated using a combination of the game duration and the final score. The networks are run concurrently, then sorted by fitness. The top 100 networks of each generation are used to produce the next generation by combining random pairs of networks, then mutating each one slightly.

## Inputs
The snake can 'see' in 8 directions: the four cardinal directions and the four diagonals. In each direction it can see three things: the distance to the game border, the distance to a food tile, and the distance to itself (assuming they are on that line of sight). The input value is calculated as the inverse of distance.

## Usage
You can download the built app to run on macOS 10.13 or later [here](https://mega.nz/file/W4Eh0IwL#CKJXhuSFu8JU-4AAdKUBjPtTWN5lEs4x8iMfOzogp8s).
