import java.util.ArrayList;

Game game;
Network network;

void setup()
{
    size(800, 700);
    frameRate(30);

    int columns = 4;
    int rows = 4;

    game = new Game(columns, rows, 2, 80);
    network = new Network(columns * rows, 9, 4);

    setupSigmoidValues();
}

void draw()
{
    background(230);
    game.draw(width / 2, height / 4);
    game.update();

    if(frameCount != 0)
    {
        network.respond(game.getInput());
        switch(network.getResponse())
        {
            case 0:
                game.move(Direction.UP);
            break;
            case 1:
                game.move(Direction.RIGHT);
            break;
            case 2:
                game.move(Direction.DOWN);
            break;
            case 3:
                game.move(Direction.LEFT);
            break;
        }
    }
}

void keyPressed()
{
    if(keyCode == UP)
    {
        game.move(Direction.UP);
    }
    else if(keyCode == RIGHT)
    {
        game.move(Direction.RIGHT);
    }
    else if(keyCode == DOWN)
    {
        game.move(Direction.DOWN);
    }
    else if(keyCode == LEFT)
    {
        game.move(Direction.LEFT);
    }
}