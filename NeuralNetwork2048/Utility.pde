enum Direction
{
    UP,
    RIGHT,
    DOWN,
    LEFT
}

float[] precalculatedSigmoidValues = new float[200];

void setupSigmoidValues()
{
    for(int i = 0; i < 200; i++)
    {
        float x = i / 20.0 - 5.0;
        precalculatedSigmoidValues[i] = 2.0 / (1.0 + exp(x * -2.0)) - 1.0;
    }
}

float getSigmoid(float input)
{
  return precalculatedSigmoidValues[constrain((int) floor((input + 5.0) * 20.0), 0, 199)];
}

float[] getRandomWeights(int length)
{
    float[] random = new float[length];
    for(int i = 0; i < length; i++)
    {
        random[i] = random(-1.0, 1.0);
    }

    return random;
}

float logBase2(float valueF)
{
    int value = round(valueF);
    switch(value)
    {
        case 0:
            return 0;
        
        case 2:
            return 1;
        
        case 4:
            return 2;
        
        case 8:
            return 3;
        
        case 16:
            return 4;
        
        case 32:
            return 5;
        
        case 64:
            return 6;
        
        case 128:
            return 7;
        
        case 256:
            return 8;
        
        case 512:
            return 9;
        
        case 1024:
            return 10;
        
        case 2048:
            return 11;
        
        case 4096:
            return 12;
        
        case 8192:
            return 13;
        
        case 16384:
            return 14;
        
        case 32768:
            return 15;
        
        case 65536:
            return 16;
        
        case 131072:
            return 17;
        
        default:
            return 0;
    }
}