//Game class that handles the board and drawing
class Game
{
    int cols;
    int rows;
    float borderWidth;
    float squareLength;

    int score;

    int[][] board;

    float LOG_2 = log(2);

    Game(int cols, int rows, float borderWidth, float squareLength)
    {
        this.cols = cols;
        this.rows = rows;
        this.borderWidth = borderWidth;
        this.squareLength = squareLength;

        reset();
    }

    //Resets the board for play
    void reset()
    {
        board = new int[cols][rows];
        for(int col = 0; col < cols; col++)
        {
            for(int row = 0; row < rows; row++)
            {
                board[col][row] = 0;
            }
        }

        int randCol = (int) random(0, cols);
        int randRow = (int) random(0, rows);

        board[randCol][randRow] = 2;

        this.score = 0;
    }

    //Draws the board centered at specified coordinates
    void draw(float centerX, float centerY)
    {
        //Calculate top left and top right coordinates
        float x = centerX - (cols / 2.0) * squareLength - ((cols + 1) / 2.0) * borderWidth;
        float y = centerY - (rows / 2.0) * squareLength - ((rows + 1) / 2.0) * borderWidth;

        for(int col = 0; col < cols; col++)
        {
            for(int row = 0; row < rows; row++)
            {
                //Coordinates for the top left of the square
                float squareX = x + ((borderWidth + squareLength) * col);
                float squareY = y + ((borderWidth + squareLength) * row);

                int number = board[col][row];

                //Draw border
                fill(0);
                //Draw up side
                rect(squareX, squareY, borderWidth * 2 + squareLength, borderWidth); 
                //Draw right side
                rect(squareX + borderWidth + squareLength, squareY, borderWidth, borderWidth * 2 + squareLength); 
                //Draw down side
                rect(squareX, squareY + borderWidth + squareLength, borderWidth * 2 + squareLength, borderWidth);
                //Draw left side
                rect(squareX, squareY, borderWidth, borderWidth * 2 + squareLength);

                //Draw the actual square
                fill(getColor(number));
                rect(squareX + borderWidth, squareY + borderWidth, squareLength, squareLength); 

                //Draw the number
                if(number != 0)
                {
                    fill(0);
                    textSize(20);
                    textAlign(CENTER, CENTER);
                    text(number, squareX + borderWidth + squareLength / 2.0, 
                        squareY + borderWidth + squareLength / 2.0);
                }
            }
        }
    }

    color getColor(int number)
    {
        if(number == 0) return color(240, 215, 145);
        float power = round(log(number) / LOG_2);
        float red = 240 - power * 15;
        float green = 215 - power * 15;
        float blue = 145 - power * 15;

        if(red < 20) red = 20;
        if(green < 20) green = 20;
        if(blue < 20) blue = 20;

        return color(red, green, blue);
    }

    void move(Move move)
    {
        move(move, board, true);
    }

    void move(Move move, int[][] board, boolean score)
    {
        
    }
}