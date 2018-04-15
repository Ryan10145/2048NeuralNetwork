//Stores the weights of a neural network and supports crossing over and mutating
class Dna
{
    float[][][] weights;
    int numOfInputs, numOfHidden, numOfOutputs;
    float fitness;

    public Dna(int numOfInputs, int numOfHidden, int numOfOutputs)
    {
        this.numOfInputs = numOfInputs;
        this.numOfHidden = numOfHidden;
        this.numOfOutputs = numOfOutputs;
        this.fitness = 0;

        //Create a series of random weights
        weights = new float[2][][];

        weights[0] = new float[numOfHidden][numOfInputs];
        weights[1] = new float[numOfOutputs][numOfHidden];
        for(int i = 0; i < weights.length; i++)
        {
            for(int j = 0; j < weights[i].length; j++)
            {
                for(int k = 0; k < weights[i][j].length; k++)
                {
                    weights[i][j][k] = random(-1.0, 1.0);
                }
            }
        }
    }

    public Dna(String fileName)
    {
        input(fileName);
    }

    //Crosses the current DNA with a mate to form a child that has parts of both DNA
    Dna cross(Dna mate)
    {
        Dna child = new Dna(numOfInputs, numOfHidden, numOfOutputs);

        for(int i = 0; i < weights.length; i++)
        {
            for(int j = 0; j < weights[i].length; j++)
            {
                for(int k = 0; k < weights[i][j].length; k++)
                {
                    if(random(1) < 0.5) child.weights[i][j][k] = this.weights[i][j][k];
                    else child.weights[i][j][k] = mate.weights[i][j][k];
                }
            }
        }

        return child;
    }

    //Randomly mutates weights to add variation
    void mutate()
    {
        for(int i = 0; i < weights.length; i++)
        {
            for(int j = 0; j < weights[i].length; j++)
            {
                for(int k = 0; k < weights[i][j].length; k++)
                {
                    if(random(1) < 0.01) weights[i][j][k] = random(-1.0, 1.0);
                }
            }
        }   
    }

    //Outputs the weights to a file so that they can be saved
    void output(String fileName)
    {
        PrintWriter writer = createWriter(fileName);

        writer.println(numOfInputs + " " + numOfHidden + " " + numOfOutputs);
        for(int i = 0; i < weights.length; i++)
        {
            for(int j = 0; j < weights[i].length; j++)
            {
                for(int k = 0; k < weights[i][j].length; k++)
                {
                    writer.println(weights[i][j][k]);
                }
            }
        }

        writer.flush();
        writer.close();
    }

    //Reads in weights from an exported file
    void input(String fileName)
    {
        try
        {
            BufferedReader reader = createReader(fileName);

            String[] data = split(reader.readLine(), " ");
            numOfInputs = Integer.parseInt(data[0]);
            numOfHidden = Integer.parseInt(data[1]);
            numOfOutputs = Integer.parseInt(data[2]);
            
            weights = new float[2][][];

            weights[0] = new float[numOfHidden][numOfInputs];
            weights[1] = new float[numOfOutputs][numOfHidden];

            for(int i = 0; i < weights.length; i++)
            {
                for(int j = 0; j < weights[i].length; j++)
                {
                    for(int k = 0; k < weights[i][j].length; k++)
                    {
                        weights[i][j][k] = Float.parseFloat(reader.readLine());
                    }
                }
            }

            reader.close();
        }
        catch(IOException e)
        {
            e.printStackTrace();
        }
    }
}