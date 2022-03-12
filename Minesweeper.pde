import de.bezier.guido.*;
public static final int NUM_ROWS = 20;
public static final int NUM_COLS = 20;
public static final int NUM_MINES = 40;
private MSButton[][] gRid; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
public boolean isLost;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void setup ()
{
  size(601, 601);
  textSize(11);
  stroke(0);
  textAlign(CENTER, CENTER);
  Interactive.make( this );

  newGame();
}

public void newGame() {
  gRid = new MSButton[NUM_ROWS][NUM_COLS];
  mines = new ArrayList <MSButton> ();
  isLost = false;

  for (int r = 0; r < NUM_ROWS; r ++)
    for (int c = 0; c < NUM_COLS; c ++)
      gRid[r][c] = new MSButton(r, c);
  
  setMines(NUM_MINES);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public void draw ()
{
  background(0);
  if (keyPressed && key == ' ')
    newGame();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public void setMines(int amount) {
  for (int i = 0; i < amount; i ++) {
    int randR = (int)(Math.random()*NUM_ROWS);
    int randC = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(gRid[randR][randC]))
      mines.add(gRid[randR][randC]);
    else
      i --;
  }
}
public int countMines(int row, int col) {
  int numMines = 0;
  for (int i = -1; i <= 1; i ++) {
    for (int j = -1; j <= 1; j ++) {
      if (isValid(row + i, col + j) && mines.contains(gRid[row + i][col + j]) && (i != row || j != col))
        numMines++;
    }
  }
  return numMines;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public boolean isValid(int r, int c) {
  return (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS);
}

public boolean isWon() {
  int sum = 0;
  for (int r = 0; r < NUM_ROWS; r ++) {
    for (int c = 0; c < NUM_COLS; c ++) {
      if (!gRid[r][c].clicked)
        sum ++;
    }
  }
  if (sum == mines.size())
    return true;
  return false;
}
public void displayLosingMessage() {
  //your code here
}
public void displayWinningMessage() {
  //your code here
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public MSButton ( int row, int col )
  {
    width = 600/NUM_COLS;
    height = 600/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol * width;
    y = myRow * height;

    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public void mousePressed () 
  {
    if (mouseButton == LEFT && !isLost && !flagged) {
      clicked = true;
      if (countMines(myRow, myCol) == 0) {
        for (int i = -1; i <= 1; i ++) {
          for (int j = -1; j <= 1; j ++) {
            if (   isValid(myRow + i, myCol + j) 
              && !gRid[myRow + i][myCol + j].clicked 
              && (i != myRow || j != myCol)
              )
              gRid[myRow + i][myCol + j].mousePressed();
          }
        }
      }
    } else if (mouseButton == RIGHT && !isLost && !clicked) {
      flagged = !flagged;
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public void draw () 
  {
    if (clicked && mines.contains(this))
      isLost = true;
    if (mines.contains(this) && isLost)
      fill(255, 0, 0);
    else if (mines.contains(this) && isWon())
      fill(0, 255, 0);
    else if (flagged)
      fill(0, 0, 255);
    else if (clicked)
      fill(0);
    else 
    fill(50);

    stroke(0);
    rect(x, y, width, height);

    if (clicked && !mines.contains(this) && countMines(myRow, myCol) > 0) {
      fill(255);
      text(countMines(myRow, myCol), x + width/2, y + height/2);
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
