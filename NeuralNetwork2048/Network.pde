//Collection of neurons in a feedforward structure that can make decisions
class Network
{
    Neuron[] inputLayer;
    Neuron[] hiddenLayer;
    Neuron[] outputLayer;

    Dna dna;

    //Creates a network with random weights with the specified amount of neurons
    public Network(int numOfInputs, int numOfHidden, int numOfOutputs)
    {
        inputLayer = new Neuron[numOfInputs];
        hiddenLayer = new Neuron[numOfHidden];
        outputLayer = new Neuron[numOfOutputs];

        dna = new Dna(numOfInputs, numOfHidden, numOfOutputs);

        for(int i = 0; i < numOfInputs; i++)
        {
            inputLayer[i] = new Neuron();
        }
        for(int i = 0; i < numOfHidden; i++)
        {
            hiddenLayer[i] = new Neuron(inputLayer, getRandomWeights(numOfInputs));
        }
        for(int i = 0; i < numOfOutputs; i++)
        {
            outputLayer[i] = new Neuron(hiddenLayer, getRandomWeights(numOfHidden));
        }
    }

    //Creates a network from DNA
    public Network(Dna dna)
    {
        inputLayer = new Neuron[dna.numOfInputs];
        outputLayer = new Neuron[dna.numOfOutputs];
        hiddenLayer = new Neuron[dna.numOfHidden];

        this.dna = dna;

        for(int i = 0; i < inputLayer.length; i++)
        {
            inputLayer[i] = new Neuron();
        }
        for(int i = 0; i < hiddenLayer.length; i++)
        {
            hiddenLayer[i] = new Neuron(inputLayer, dna.weights[0][i]);
        }
        for(int i = 0; i < outputLayer.length; i++)
        {
            outputLayer[i] = new Neuron(hiddenLayer, dna.weights[1][i]);
        }
    }

    //Returns the index of the neuron with the greatest output in the output layer
    int getResponse()
    {
        int max = 0;
        for(int i = 1; i < outputLayer.length; i++)
        {
            if(outputLayer[i].output > outputLayer[max].output) max = i;
        }

        return max;
    }

    //Takes in an input board and calculates the network's response
    float[] respond(float[] board)
    {
        float[] responses = new float[outputLayer.length];

        for(int i = 0; i < inputLayer.length; i++)
        {
            inputLayer[i].output = board[i];
        }
        for(int i = 0; i < hiddenLayer.length; i++)
        {
            hiddenLayer[i].respond();
        }
        for(int i = 0; i < outputLayer.length; i++)
        {
            outputLayer[i].respond();
            responses[i] = outputLayer[i].output;
        }

        return responses;
    }

    //Displays the neural network at given coordinates
    void show(float x, float y)
    {
        for(int i = 0; i < inputLayer.length; i++)
        {
            
        }
        for(int i = 0; i < hiddenLayer.length; i++)
        {

        }
        for(int i = 0; i < outputLayer.length; i++)
        {

        }
    }

    //Sets the DNA of a network
    void setDNA(Dna dna)
    {
        this.dna = dna;

        for(int i = 0; i < inputLayer.length; i++)
        {
            inputLayer[i] = new Neuron();
        }
        for(int i = 0; i < hiddenLayer.length; i++)
        {
            hiddenLayer[i] = new Neuron(inputLayer, dna.weights[0][i]);
        }
        for(int i = 0; i < outputLayer.length; i++)
        {
            outputLayer[i] = new Neuron(hiddenLayer, dna.weights[1][i]);
        }
    }
}