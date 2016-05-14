\header {
  title = "4 String Bass Example"
}
\version "2.18.2"
<<
  \new Voice \with {
    \omit StringNumber
  } {
    \clef "bass_8"
    \relative c, {
      c4 d e f
    }
  }
  \new TabStaff \with {
    stringTunings = #bass-tuning
  } {
    \relative c, {
      c4 d e f
    }
  }
>>