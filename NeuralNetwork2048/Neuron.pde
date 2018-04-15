//A basic feed forward neuron
class Neuron
{
    Neuron[] inputs;
    float[] weights;
    float output;

    float x;
    float y;
    
    public Neuron()
    {
        
    }

    public Neuron(Neuron[] inputs, float[] weights)
    {
        this.inputs = new Neuron[inputs.length];
        this.weights = new float[inputs.length];
        
        for(int i = 0; i < inputs.length; i++)
        {
            this.inputs[i] = inputs[i];
            this.weights[i] = weights[i];
        }
    }

    //Calculates the output value of a neuron
    void respond()
    {
        float sum = 0.0;

        for(int i = 0; i < inputs.length; i++)
        {
            sum += inputs[i].output * weights[i];
        }

        output = getSigmoid(sum);
    }

    //Sets the weights of a neuron
    void setWeights(float[] weights)
    {
        this.weights = weights;
    }

    //Displays a neuron at the specified coordinates
    void show(float x, float y)
    {
        this.x = x;
        this.y = y;

        float radius = 20;

        fill(128 * (1 - output));
        stroke(0);
        strokeWeight(1);
        ellipse(x, y, radius, radius);
    }

    void showConnections()
    {
        if(inputs != null)
        {
            for(int i = 0; i < inputs.length; i++)
            {
                if(weights[i] > 0.5) 
                {
                    stroke(0, 255 * weights[i] - 128, 0);
                    line(inputs[i].x, inputs[i].y, this.x, this.y);
                }
            }
        }
    }
}