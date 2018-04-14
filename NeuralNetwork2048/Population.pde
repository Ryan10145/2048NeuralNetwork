//Manages creating multiple networks, crossing them, mutating them, and breeding new generations based on fitness
class Population
{
    Dna[] currentPopulation;
    int current;
    int generationCount;

    Network network;
    Game game;

    Dna best;
    int[][] bestBoard;

    //Creates a population that manages a game with a specified amount of columns and rows
    public Population(int cols, int rows)
    {
        currentPopulation = new Dna[100];
        generationCount = 0;

        for(int i = 0; i < currentPopulation.length; i++)
        {
            currentPopulation[i] = new Dna(cols * rows, 9, 4);
        }

        current = 0;
        network = new Network(currentPopulation[current]);
        game = new Game(cols, rows, 2, 80);

        best = null;
        bestBoard = new int[cols][rows];
    }

    //Runs all of the networks in the current population
    void run()
    {
        for(int i = 0; i < currentPopulation.length; i++)
        {
            game.reset();
            network.setDNA(currentPopulation[i]);
            
            while(!game.gameOver)
            {
                float[] responses = network.respond(game.getInput());

                boolean moved = false;
                while(!moved)
                {
                    switch(getMax(responses))
                    {
                        case 0:
                            if(!game.move(Direction.UP)) responses[0] = -100; 
                            else moved = true;
                        break;
                        case 1:
                            if(!game.move(Direction.RIGHT)) responses[1] = -100;
                            else moved = true;
                        break;
                        case 2:
                            if(!game.move(Direction.DOWN)) responses[2] = -100;
                            else moved = true;
                        break;
                        case 3:
                            if(!game.move(Direction.LEFT)) responses[3] = -100;
                            else moved = true;
                        break;
                        default:
                            moved = true;
                            game.update();
                        break;
                    }
                }
                game.update();
            }

            currentPopulation[i].fitness += game.score * game.score;
            if(best == null)
            {
                best = currentPopulation[i];
                for(int col = 0; col < game.cols; col++)
                {
                    for(int row = 0; row < game.rows; row++)
                    {
                        bestBoard[col][row] = game.board[col][row];
                    }
                }
            }
            else if(currentPopulation[i].fitness > best.fitness)
            {
                best = currentPopulation[i];
                for(int col = 0; col < game.cols; col++)
                {
                    for(int row = 0; row < game.rows; row++)
                    {
                        bestBoard[col][row] = game.board[col][row];
                    }
                }
            }

            println("Current Species: " + i + "\tScore: " + game.score);
        }
    }

    //Crosses the best neural networks and randomly mutates them
    void update()
    {
        ArrayList<Dna> matingPool = new ArrayList<Dna>();
        float bestFitness = getMaxFitness();
        for(Dna dna : currentPopulation)
        {
            float count = map(dna.fitness, 0, bestFitness, 0, 100);
            for(int i = 0; i < count; i++) matingPool.add(dna);
        }
        
        for(int i = 0; i < currentPopulation.length; i++)
        {
            Dna dna1 = matingPool.get(int(random(matingPool.size())));
            Dna dna2 = matingPool.get(int(random(matingPool.size())));
            
            Dna child = dna1.cross(dna2);
            child.mutate();
            
            currentPopulation[i] = child;
        }
        
        generationCount++;
        
        println(generationCount + " : " + bestFitness);
    }
    
    //Gets the highest fitness of the generation;
    float getMaxFitness()
    {
        float highest = 0;
        for(int i = 0; i < currentPopulation.length; i++)
        {
            if(currentPopulation[i].fitness > highest)
            {
                highest = currentPopulation[i].fitness;
            }
        }

        return highest;
    }

    //Gets the best network of the generation
    Dna getBest()
    {
        Dna best = null;

        for(int i = 0; i < currentPopulation.length; i++)
        {
            if(best == null)
            {
                best = currentPopulation[i];
            }
            else if(currentPopulation[i].fitness > best.fitness)
            {
                best = currentPopulation[i];
            }
        }

        return best;
    }

    //Draws the game
    void show(float centerX, float centerY)
    {
        game.draw(centerX, centerY);
    }
}