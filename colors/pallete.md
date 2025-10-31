/* Terminal colors (16 first used in escape sequence) */
static const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#050601", /* black   */
  [1] = "#e77d28", /* red     */
  [2] = "#b4c22f", /* green   */
  [3] = "#e9d880", /* yellow  */
  [4] = "#e77d28", /* blue    */
  [5] = "#e9d880", /* magenta */
  [6] = "#b4c22f", /* cyan    */
  [7] = "#ded1ba", /* white   */

  /* 8 bright colors */
  [8]  = "#0c0e02", /* black   */
  [9]  = "#f7862b", /* red     */
  [10] = "#c6d534", /* green   */
  [11] = "#e9e480", /* yellow  */
  [12] = "#f7862b", /* blue    */
  [13] = "#e9e480", /* magenta */
  [14] = "#f7862b", /* cyan    */
  [15] = "#efe1c8", /* white   */

  /* special colors */
  [256] = "#050601", /* background */
  [257] = "#ded1ba", /* foreground */
};

/*
 * Default colors (colorname index)
 * foreground, background, cursor
 */
static unsigned int defaultfg = 257;
static unsigned int defaultbg = 256;
static unsigned int defaultcs = 257;

/*
 * Colors used, when the specific fg == defaultfg. So in reverse mode this
 * will reverse too. Another logic would only make the simple feature too
 * complex.
 */
static unsigned int defaultitalic = 7;
static unsigned int defaultunderline = 7;
