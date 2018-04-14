import java.util.ArrayList;

Game game;

void setup()
{
    size(800, 700);
    game = new Game(4, 4, 2, 80);
}

void draw()
{
    game.draw(width / 2, height / 4);
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