\version "2.14.2"

\header {
  title = "Andantino"
  composer = "Fernando Sor"
  mutopiatitle = "Andantino"
  mutopiacomposer = "SorF"
  mutopiainstrument = "Guitar"
  source = "Statens musikbibliotek - The Music Library of Sweden"
  style = "Romantic"
  copyright = "Creative Commons Attribution-ShareAlike 3.0"
  maintainer = "Glen Larsen"
  maintainerEmail = "glenl at glx.com"
 footer = "Mutopia-2011/12/12-1810"
 tagline = \markup { \override #'(box-padding . 1.0) \override #'(baseline-skip . 2.7) \box \center-column { \small \line { Sheet music from \with-url #"http://www.MutopiaProject.org" \line { \teeny www. \hspace #-0.5 MutopiaProject \hspace #-0.5 \teeny .org \hspace #0.5 } • \hspace #0.5 \italic Free to download, with the \italic freedom to distribute, modify and perform. } \line { \small \line { Typeset using \with-url #"http://www.LilyPond.org" \line { \teeny www. \hspace #-0.5 LilyPond \hspace #-0.5 \teeny .org } by \maintainer \hspace #-0.6 . \hspace #0.5 Copyright © 2011. \hspace #0.5 Reference: \footer } } \line { \teeny \line { Licensed under the Creative Commons Attribution-ShareAlike 3.0 (Unported) License, for details see: \hspace #-0.5 \with-url #"http://creativecommons.org/licenses/by-sa/3.0" http://creativecommons.org/licenses/by-sa/3.0 } } } }
}

\layout {
  indent = 60\pt
  short-indent = 0\pt
  ragged-bottom = ##t
  ragged-last-bottom = ##t
}

%showLastLength = r2.*9
%mbreak = \break
mbreak = {}

upperVoice = \relative c' {
  \voiceOne
  \slurDown
  \partial 4 a'4 |
  a4 gis fis |
  fis4 e d |
  <gis, d'>2. |
  <a cis>4 r <e a> |
  a gis a |
  <b e>4 d <a cis> |
  <gis b>2. |
  r4 r a' |
  \mbreak
  a4 gis fis |
  fis4 eis d |
  d4 cis <gis b> |
  <fis a>4 r <a c fis> |
  <a cis! e>4 dis8[ e] cis[ a] |
  r4 <e cis'> <d b'> |
  <cis a'>4 r r |
  <fis d'>2 <e cis'>4 |
  <dis bis'>2 <e cis'>4 |
  \mbreak
  <d b'>4 fis gis |
  <cis, a'>2 r4 |
  <d' fis>2 <cis e>4 |
  <bis dis>2 <cis e>4 |
  << { d!4 b <gis e'>4 } \\ { \voiceThree fis2 s4 } >> |
  <a cis>2. |
  \repeat volta 2 {
    <gis cis>4 <gis cis>4 <gis cis>4 |
    <a cis>4 r8 fis[ a cis] |
    \mbreak
    fis4 a <b, cis gis'>4 |
    <a cis fis>2 r4 |
    <a b>4 <a b> <a b> |
    <gis b>4 r8 gis[ b e] |
    gis4 fis dis |
    e2. |
    e4 f8[( e) d c] |
    c4 b g |
    \mbreak
    c4 d8[ c b c] |
    <g cis!>4 d' g, |
    e'8[ g,] f'[( e) d c] |
    c8[( b)] a[ g a b] |
    \acciaccatura{d8} cis8[ b] cis[ d e f] |
    r8 g,[ cis! g d' g,] |
    r4 <g e'> <gis d' e> |
    \mbreak
    <a c e>4 f'8([ e) d c] |
    r4 <a b>4 <a b>4 |
    <gis b>2 r4 |
    b8[ d] a[ c] gis[ b] |
    <a c>2.-> |
    c8[ e] b[ d] a[ c] |
    <gis b>2. |
    d'8[ b'] c,[ a'] b,[ gis'] |
    \mbreak
    <c, a'>2.-> |
    e8[ c'] d,[ b'] c,[ a'] |
    <b, gis'>2 <c dis b'>4 |
    <b e gis>2 <c, dis a'>4 |
    <b e gis>2 <cis' e a>4 |
    a'4 gis fis |
    fis4 eis fis |
    fis4 e! d |
    \mbreak
    d4 cis r |
    <gis b>4 <gis b>4 <gis b>4 |
    <a e'>4 fis'8([ e) d cis] |
    <gis b>4 <gis b>4 <gis b>4 |
    <a e'>2. |
    <b eis>4 <b eis>4 <b eis>4 |
    gis'4.( fis8)[ d b] |
    a4 cis <d, gis b>4 |
    <cis a'>4 r r |
    \mbreak
    r8 fis[ a d e, cis'] |
    r8 dis,[ a' c e, cis'] |
    r8 d,![ gis b cis b] |
    <cis, a'>4 r r |
    r8 a'[ d fis cis e] |
    r8 a,[ c dis cis e] |
    r8 fis,[ a d] <gis, b>4 |
    \mbreak
    <a cis>2 r4 |
    e2. |
    e2. |
    << { cis'4 b cis } \\ {} \\ { e,2.^\markup{\italic "cresc."} } >> |
    << { d'4 b gis } \\ {} \\ { e2. } >> |
    << { cis'4 b a } \\ {} \\ { e'2. } >> |
    % << { \stemDown cis'4 \stemUp b a } \\ {} \\ { e'2. } >> |
    <a, b fis'>2.-> |
    r4 <b d gis>2 |
    <cis a'>2.->
  }
}

lowerVoice = \relative c' {
  \voiceTwo
  \partial 4 <cis e>4\p |
  <b d>2 <a cis>4 |
  <gis b>2 <e gis>4 |
  eis2. |
  fis4 s cis |
  <b d>2 <a cis>4 |
  gis2 a4 |
  e4 gis b |
  e4 e,4 <cis'' e> |
  <b d>2 <a cis>4 |
  <gis b>2 <fis a>4 |
  <eis gis>2 cis4 |
  d4 r dis |
  e4 r r |
  e,2 gis4 |
  a4 a\p a | 
  \repeat unfold 7 { a4 a a | }
  a2. |
  \repeat volta 2 {
    eis4\p eis eis |
    fis4 a r |
    r4 r eis'\f |
    fis4 fis, r |
    b4\mf dis b |
    e,8[ b'] e4 r |
    r4 <ais cis> a |
    gis4 e e, |
    <c' g'>2. |
    <d g>2 f4 |
    <e g>2. |
    b4 r r |
    c2. |
    d2. |
    e2. |
    b2. |
    c2 b4 |
    a4 r r |
    d2 dis4 |
    e4 e, e |
    e4 e e |
    e4\sfz e e |
    \repeat unfold 3 { e4 e e | }
    e4\sfz e e | 
    \repeat unfold 3 { e4 e e | }
    e4 e s |
    <b'' d>2 <a cis>4 |
    <gis b>2 <a cis>4 |
    <gis b>2 <fis a>4 |
    %
    <eis gis>2 r4 |
    d4 d d |
    cis4\f r r |
    d4 d d |
    cis2. |
    cis4 cis cis |
    <d a'>2. |
    e2 e,4 |
    a4 a\p a |
    %
    a4 r r |
    a2. |
    a2. |
    a4 a a |
    a2. |
    a2. |
    a2. |
    %
    a2 r4 |
    a4\p a a |
    b4 gis e |
    a4 gis a |
    b4 gis e |
    a4 b cis |
    d2. |
    e,4\ff e' e, |
    <a a'>2.
  }
}

\score {
  <<
    \new Staff = "Guitar"
    <<
      \set Staff.instrumentName = #"Guitar"
      \set Staff.midiInstrument = #"acoustic guitar (nylon)"
      \clef "treble_8"
      \time 3/4
      \key a \major
      \context Voice = "upperVoice" \upperVoice
      \context Voice = "lowerVoice" \lowerVoice
    >>
%{
    \new TabStaff = "guitar tab"
    <<
      \clef moderntab
      \context TabVoice = "upperVoice" \upperVoice
      \context TabVoice = "lowerVoice" \lowerVoice
    >>
%}
  >>
  \layout {}
  \midi {
    \context {
      \Score
      tempoWholesPerMinute = #(ly:make-moment 100 4)
    }
  }
}
