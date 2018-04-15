//Game class that handles the board and drawing
class Game
{
    int cols;
    int rows;
    float borderWidth;
    float squareLength;

    int score;
    boolean gameOver;

    int[][] board;

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
        createNewTile(board);

        this.score = 0;
        gameOver = false;
    }

    //Draws the board centered at specified coordinates
    void draw(float centerX, float centerY)
    {
        //Calculate top left and top right coordinates
        float x = centerX - (cols / 2.0) * squareLength - ((cols + 1) / 2.0) * borderWidth;
        float y = centerY - (rows / 2.0) * squareLength - ((rows + 1) / 2.0) * borderWidth - 10;

        for(int col = 0; col < cols; col++)
        {
            for(int row = 0; row < rows; row++)
            {
                //Coordinates for the top left of the square
                float squareX = x + ((borderWidth + squareLength) * col);
                float squareY = y + ((borderWidth + squareLength) * row);

                int number = board[col][row];

                //Draw border
                fill(146, 132, 120);
                noStroke();
                int filletRadius = 4;
                int borderWidthPadding = 2;
                //Draw up side
                rect(squareX - borderWidthPadding / 2, squareY - borderWidthPadding / 2,
                    borderWidth * 2 + squareLength, borderWidth + borderWidthPadding, filletRadius); 
                //Draw right side
                rect(squareX + borderWidth + squareLength - borderWidthPadding / 2, squareY - borderWidthPadding / 2,
                    borderWidth + borderWidthPadding, borderWidth * 2 + squareLength, filletRadius); 
                //Draw down side
                rect(squareX - borderWidthPadding / 2, squareY + borderWidth + squareLength - borderWidthPadding / 2,
                    borderWidth * 2 + squareLength, borderWidth + borderWidthPadding, filletRadius);
                //Draw left side
                rect(squareX - borderWidthPadding / 2, squareY - borderWidthPadding / 2,
                    borderWidth + borderWidthPadding, borderWidth * 2 + squareLength, filletRadius);

                //Draw the actual square
                fill(getColor(number));
                rect(squareX + borderWidth, squareY + borderWidth, squareLength, squareLength, filletRadius); 

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

        fill(0);
        textSize(20);
        textAlign(CENTER, CENTER);
        text("Score: " + score, centerX, 
            centerY + (rows / 2.0 + 0.5) * squareLength - ((rows + 1) / 2.0) * borderWidth);
        if(gameOver) 
        {
            text("Game Over!", centerX,
                centerY + (rows / 2.0 + 1) * squareLength - ((rows + 1) / 2.0) * borderWidth);
        }
    }

    //Applies a move to a main game board
    //Returns whether the move actually did something
    boolean move(Direction direction)
    {
        return move(direction, board, true);
    }
    
    //Returns whether a move is possble in a given direction
    boolean checkMove(Direction direction)
    {
        int[][] testBoard = new int[cols][rows];
        for(int col = 0; col < cols; col++)
        {
            for(int row = 0; row < rows; row++)
            {
                testBoard[col][row] = board[col][row];
            }
        }

        return move(direction, testBoard, false);
    }

    //Applies a move to a given board and whether or not to count towards scoring
    //Returns whether the move actually did something
    boolean move(Direction direction, int[][] board, boolean incrementScore)
    {
        boolean moved = false; //Whether or not the move has actually resulted in something
        switch(direction)
        {
            case UP:
                for(int col = 0; col < cols; col++)
                {
                    for(int row = 0; row < rows; row++)
                    {
                        if(row != 0 && board[col][row] != 0)
                        {
                            boolean flag = false;

                            int step = 0;
                            for(int rowA = row - 1; rowA >= 0; rowA--)
                            {
                                if(board[col][rowA] == 0) step++;
                                else break;
                            }
                            if(step != 0)
                            {
                                for(int rowB = row; rowB < rows; rowB++)
                                {
                                    board[col][rowB - step] = board[col][rowB];
                                    board[col][rowB] = 0;
                                    flag = true;
                                    moved = true;
                                }
                            }

                            if(board[col][row] == board[col][row - 1])
                            {
                                board[col][row - 1] *= 2;
                                if(incrementScore) score += board[col][row - 1];
                                board[col][row] = 0;
                                for(int rowB = row + 1; rowB < rows; rowB++)
                                {
                                    board[col][rowB - 1] = board[col][rowB];
                                    board[col][rowB] = 0;
                                    moved = true;
                                }
                            }

                            if(flag) row = 0;
                        }
                    }
                }
            break;
            case RIGHT:
                for(int col = cols - 1; col >= 0; col--)
                {
                    for(int row = 0; row < rows; row++)
                    {
                        if(col != cols - 1 && board[col][row] != 0)
                        {
                            boolean flag = false;

                            int step = 0;
                            for(int colA = col + 1; colA < cols; colA++)
                            {
                                if(board[colA][row] == 0) step++;
                                else break;
                            }
                            if(step != 0)
                            {
                                for(int colB = col; colB >= 0; colB--)
                                {
                                    board[colB + step][row] = board[colB][row];
                                    board[colB][row] = 0;
                                    flag = true;
                                    moved = true;
                                }
                            }

                            if(board[col][row] == board[col + 1][row])
                            {
                                board[col + 1][row] *= 2;
                                if(incrementScore) score += board[col + 1][row];
                                board[col][row] = 0;
                                for(int colB = col - 1; colB >= 0; colB--)
                                {
                                    board[colB + 1][row] = board[colB][row];
                                    board[colB][row] = 0;
                                    moved = true;
                                }
                            }

                            if(flag) col = cols - 1;
                        }
                    }
                }
            break;
            case DOWN:
                for(int col = 0; col < cols; col++)
                {
                    for(int row = rows - 1; row >= 0; row--)
                    {
                        if(row != rows - 1 && board[col][row] != 0)
                        {
                            boolean flag = false;

                            int step = 0;
                            for(int rowB = row + 1; rowB < rows; rowB++)
                            {
                                if(board[col][rowB] == 0) step++;
                                else break;
                            }
                            if(step != 0)
                            {
                                for(int rowA = row; rowA >= 0; rowA--)
                                {
                                    board[col][rowA + step] = board[col][rowA];
                                    board[col][rowA] = 0;
                                    flag = true;
                                    moved = true;
                                }
                            }

                            if(board[col][row] == board[col][row + 1])
                            {
                                board[col][row + 1] *= 2;
                                if(incrementScore) score += board[col][row + 1];
                                board[col][row] = 0;
                                for(int rowA = row - 1; rowA >= 0; rowA--)
                                {
                                    board[col][rowA + 1] = board[col][rowA];
                                    board[col][rowA] = 0;
                                    moved = true;
                                }
                            }

                            if(flag) row = rows - 1;
                        }
                    }
                }
            break;
            case LEFT:
                for(int col = 0; col < cols; col++)
                {
                    for(int row = 0; row < rows; row++)
                    {
                        if(col != 0 && board[col][row] != 0)
                        {
                            boolean flag = false;

                            int step = 0;
                            for(int colA = col - 1; colA >= 0; colA--)
                            {
                                if(board[colA][row] == 0) step++;
                                else break;
                            }
                            if(step != 0)
                            {
                                for(int colB = col; colB < cols; colB++)
                                {
                                    board[colB - step][row] = board[colB][row];
                                    board[colB][row] = 0;
                                    flag = true;
                                    moved = true;
                                }
                            }

                            if(board[col][row] == board[col - 1][row])
                            {
                                board[col - 1][row] *= 2;
                                if(incrementScore) score += board[col - 1][row];
                                board[col][row] = 0;
                                for(int colB = col + 1; colB < cols; colB++)
                                {
                                    board[colB - 1][row] = board[colB][row];
                                    board[colB][row] = 0;
                                    moved = true;
                                }
                            }

                            if(flag) col = 0;
                        }
                    }
                }
            break;
            default:

            break;
        }

        if(moved)
        {
            createNewTile(board);
        }

        return moved;
    }

    //Returns 1D array of the board for feeding into the neural network
    //Takes all of the values and returns them relative to the max value
    float[] getInput()
    {
        float[] array = new float[cols * rows];
        int max = 0;

        for(int col = 0; col < cols; col++)
        {
            for(int row = 0; row < rows; row++)
            {
                array[col * cols + row] = board[col][row];
                if(board[col][row] > max) max = board[col][row];
            }
        }

        float maxLog = logBase2(max);
        for(int col = 0; col < cols; col++)
        {
            for(int row = 0; row < rows; row++)
            {
                if(array[col * cols + row] != 0)
                {
                    array[col * cols + row] = logBase2(array[col * cols + row]) / maxLog;
                }
            }
        }

        return array;
    }

    //Checks if the game has ended
    void update()
    {
        if(!gameOver)
        {
            if(!(checkMove(Direction.UP) || checkMove(Direction.RIGHT)
                || checkMove(Direction.DOWN) || checkMove(Direction.LEFT))) //If cannot move in any direction
            {
                gameOver = true;
            }
        }
    }

    void createNewTile(int[][] board)
    {
        //Generate a list of all possible locations for a new square
        ArrayList<int[]> possible = new ArrayList<int[]>();
        for(int col = 0; col < cols; col++)
        {
            for(int row = 0; row < rows; row++)
            {
                if(board[col][row] == 0) possible.add(new int[] {col, row});
            }
        }

        //If there are possible locations
        if(possible.size() > 0)
        {
            //Get a random coordinate
            int randomIndex = (int) random(0, possible.size());
            int[] randomCoords = possible.get(randomIndex);

            int number = random(1) > 0.1 ? 2 : 4; //10% chance for a 4 
            board[randomCoords[0]][randomCoords[1]] = number;
        }
    }
}