class Button
{
    float x;
    float y;
    float w;
    float h;

    color fillColor, hoverColor;
    String text;

    public Button(String text, float x, float y, float w, float h, color fillColor, color hoverColor)
    {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;

        this.fillColor = fillColor;
        this.hoverColor = hoverColor;

        this.text = text;
    }

    boolean mouseOver()
    {
        return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
    }

    void show()
    {
        noStroke();
        if(mouseOver()) fill(hoverColor);
        else fill(fillColor);

        rectMode(CORNER);
        rect(x, y, w, h);

        fill(0);
        textAlign(CENTER, CENTER);
        textSize(20);
        text(text, x + w / 2, y + h / 2);
    }
}