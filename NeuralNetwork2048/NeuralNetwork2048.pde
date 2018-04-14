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