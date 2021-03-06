%%--------------------------------------------------------------------
% LilyPond typesetting of Rachmaninoff Prelude Op. 23 No. 2
%%--------------------------------------------------------------------

%----- Notes ---------------------------------------------------------
% - Due to nature of this piece, visibility of most tuplet numbers are
%   explicitly specified to avoid confusion
% - Bar 37 is TimeScaledMusic applying grace styles. First 2 notes are
%   lengthened so whole passage becomes a 4/4 for easier counting (with
%   additional effect of emulating real performance). Left hand notes
%   are individually scaled to align with right hand notes.
% - Still considering whether to follow all tuplet number visibility
%   in any edition. Gutheil and Muzyka differ a little in this area,
%   and showing numbers again in 2nd occurance of main theme is repetitive

%----- Known problems ------------------------------------------------
% - It is next to impossible to have original layout; note density is
%   too high. On stable (2.18) version, setting system-count achieves the
%   best result, though best option is to use devel version.
% - This piece is basically a showcase for Lilypond's inept handling
%   of tuplet number positioning. Most problems originate from tuplet
%   number being placed at mid-point of tuplet bracket
%   * Tuplet numbers at horizontal mid-point is wrong according to
%     Gardner Read's Music Notation
%   * Most vertical positions are wrong as well when displayed w/o bracket
%   * Adjustment of number positions not quite done yet
% - Accidental mode for IMSLP editions are somewhere between old romantic
%   style and 20th century style; choosing default here, because changing
%   accidental mode increases page count (!)


%%--------------------------------------------------------------------
% The Mutopia Project
% LilyPond template for keyboard solo piece
%%--------------------------------------------------------------------

% It is possible to lower requirement to 2.18.x but some problems
% may surface, like bad tuplet layout in bar 6 left hand
\version "2.19.7"
 
%---------------------------------------------------------------------
%--Paper-size setting must be commented out or deleted upon submission.
%--LilyPond engraves to paper size A4 by default.
%--Uncomment the setting below to validate your typesetting
%--in "letter" sizing.
%--Mutopia publishes both A4 and letter-sized versions.
%---------------------------------------------------------------------
% #(set-default-paper-size "letter")
 
%--Default staff size is 20
% #(set-global-staff-size 20)
 
% from openlilylib
#(define (calculate-version ver-list)
   ;; take a LilyPond version number as a three element list
   ;; and calculate a integer representation
   (+ (* 1000000 (first ver-list)) 
     (* 1000 (second ver-list)) 
     (third ver-list)))

\paper {
  top-margin = 8\mm                              %-minimum top-margin: 8mm
  top-markup-spacing.basic-distance = #6         %-dist. from bottom of top margin to the first markup/title
  markup-system-spacing.basic-distance = #5      %-dist. from header/title to first system
  top-system-spacing.basic-distance = #12        %-dist. from top margin to system in pages with no titles
  last-bottom-spacing.basic-distance = #12       %-pads music from copyright block
  
  % with 2.19 version the score is rendered into most compat layout by
  % default, but for 2.18 the whole thing explode into 11-12 pages, so
  % force system-count on older versions (the only one effective setting here)
  % 39 is the minimum without fatal layout problem
  #(if (> 2019000 (calculate-version (ly:version)))
       (define system-count 39))

  % ragged-right = ##f
  ragged-last = ##f
  ragged-bottom = ##f
  ragged-last-bottom = ##f
  
  % debug-slur-scoring = ##t
}

%---------------------------------------------------------------------
%--Refer to http://www.mutopiaproject.org/contribute.html
%--for usage and possible values for header variables.
%---------------------------------------------------------------------
\header {
  title = "Prelude II"
  composer = "Sergei Rachmaninoff (1873-1943)"
  opus = "Op. 23, No 2"
  date = "1901"
  style = "Romantic"
  license = "Creative Commons Attribution-ShareAlike 4.0"
  %% Gutheil edition on IMSLP is also cross-referenced
  source = "IMSLP - Muzyka and Gutheil editions"
 
  maintainer = "Abel Cheung"
  maintainerEmail = "abelcheung at gmail dot com"
  mutopiatitle = "Prelude Op. 23, No. 2"
  mutopiaopus = "Op. 23"
  mutopiacomposer = "RachmaninoffS"
  mutopiainstrument = "Piano"
 
 footer = "Mutopia-2014/07/19-1960"
 copyright =  \markup { \override #'(baseline-skip . 0 ) \right-column { \sans \bold \with-url #"http://www.MutopiaProject.org" { \abs-fontsize #9  "Mutopia " \concat { \abs-fontsize #12 \with-color #white \char ##x01C0 \abs-fontsize #9 "Project " } } } \override #'(baseline-skip . 0 ) \center-column { \abs-fontsize #12 \with-color #grey \bold { \char ##x01C0 \char ##x01C0 } } \override #'(baseline-skip . 0 ) \column { \abs-fontsize #8 \sans \concat { " Typeset using " \with-url #"http://www.lilypond.org" "LilyPond " \char ##x00A9 " " 2014 " by " \maintainer " " \char ##x2014 " " \footer } \concat { \concat { \abs-fontsize #8 \sans{ " " \with-url #"http://creativecommons.org/licenses/by-sa/4.0/" "Creative Commons Attribution ShareAlike 4.0 International License " \char ##x2014 " free to distribute, modify, and perform" } } \abs-fontsize #13 \with-color #white \char ##x01C0 } } }
 tagline = ##f
}

%--------Tuplet related funcs and shorthands

showTupletOnce = { \once \override TupletNumber.stencil = #ly:tuplet-number::print }
hideTupletOnce = { \once \omit TupletNumber }

showTupletTemp = { \temporary \override TupletNumber.stencil = #ly:tuplet-number::print }
hideTupletTemp = { \temporary \omit TupletNumber }

revertTuplet = { \revert TupletNumber.stencil }

% https://code.google.com/p/lilypond/issues/detail?id=2190
% tuplet placement is sometimes not optimal, happens a lot here

% move tuplet number for a relative offset
% should obsolete this because it is hard to predict where tuplets would
% placed when layout changes
moveTuplet =
#(define-music-function (parser location offset)
   (number?)
   #{ \once \offset Y-offset $offset TupletNumber #}
)

% force invisible bracket to absolute position so tuplet number is drawn
% at desired location. Better used with avoid-* properties
moveTupletAbs = 
#(define-music-function (parser location offset whiteout)
   (number? boolean?)
   (define pos (cons offset offset))
   #{
     \once \override TupletNumber.whiteout = #whiteout
     \once \override TupletBracket.positions = $pos
   #}
)

%-------- Custom dynamics

ffmarcato = \tweak DynamicText.self-alignment-X #LEFT
#(make-dynamic-script
  (markup #:line
    (#:dynamic "ff"
     #:normal-text #:larger #:italic "sempre marcato")))

%-------- fake dynamics and tempo for midi control

hideTempo = { % for controlling midi speed
  \once \omit MetronomeMark
}

hideDynamics = { % for controlling midi volume for each voice
  \once \omit DynamicText
}

%-------- Other funcs

ottavaUp = {
  \ottava #1 \set Staff.ottavation = #"8"
}

% Emulate grace note visual style (bar 37)
% http://lists.gnu.org/archive/html/lilypond-user/2013-05/msg00415.html
graceStyle = \applyContext
#(lambda (context)
   (map (lambda (x) (ly:context-pushpop-property
                     context
                     (cadr x)
                     (caddr x)
                     (cadddr x)))
     (ly:context-property context 'graceSettings)))

% unapply grace note style
noGraceStyle = \applyContext
#(lambda (context)
   (map (lambda (x) (ly:context-pushpop-property
                     context
                     (cadr x)
                     (caddr x)))
     (ly:context-property context 'graceSettings)))

% show/hide fingering
toggleFinger =
#(define-music-function (parser location finger-visible music)
   (boolean? ly:music?)
   (define stencil (if finger-visible ly:text-interface::print #f))
   #{
     \temporary \override Fingering.stencil = #stencil
     \hideTupletTemp
     $music
     \revertTuplet
     \revert Fingering.stencil
   #}
)

% show/hide tuplet number
toggleTup =
#(define-music-function (parser location tup-visible music)
   (boolean? ly:music?)
   (define stencil (if tup-visible ly:tuplet-number::print #f))
   #{
     \temporary \override TupletNumber.stencil = #stencil
     $music
     \revertTuplet
   #}
)

%-------- The following funcs are for repeatedly adding articulation

#(define tied? #f)

#(define (check-tie e)
   (if (eq? 'TieEvent (ly:music-property e 'name))
       (set! tied? #t)))

% Idea from http://lists.gnu.org/archive/html/lilypond-user/2008-06/msg00019.html
#(define (add-articulation articulation m)
   (let (
          (name    (ly:music-property m 'name))
          (es      (ly:music-property m 'elements))
          (e       (ly:music-property m 'element))
          (ar-list (ly:music-property m 'articulations))
          (ar      (make-music 'ArticulationEvent 'articulation-type articulation)))
     (cond
      ((ly:music? e)
       (if (not (eq? name 'GraceMusic)) (add-articulation articulation e)))
      ((eq? name 'TieEvent) (set! tied? #t))
      ((list? es)  ; including case where elements property doesn't exist
        (cond
         ((eq? name 'EventChord)
          (begin
           (if (and (not tied?)
                    ; no very reliable way to determine if an EventChord contains notes
                    ; but enough for use here
                    (or (ly:duration? (ly:music-property m 'duration))
                        (memq 'NoteEvent
                          (map (lambda(x) (ly:music-property x 'name)) es))))
               ; Attaching same articulation multiple times is not harmful, so
               ; not bother checking if accent already exists. Same below.
               (ly:music-set-property! m 'elements
                 (append es (list ar))))
           (set! tied? #f)
           (for-each check-tie es)))
         ((eq? name 'NoteEvent)
          (begin
           (if (not tied?)
               (ly:music-set-property! m 'articulations
                 (append ar-list (list ar))))
           (set! tied? #f)
           (for-each check-tie ar-list)))
         (else (if (not (null? es))
                   (for-each
                    (lambda(x) (add-articulation articulation x)) es))))))))


% for supported articulation list, see lilypond doc section A.13
addArticulation =
#(define-music-function (parser location articulation mus)
   (string? ly:music?)
   "Add same articulation to all notes except rests, grace and tied notes"
   (set! tied? #f)
   (for-each
    (lambda(x) (add-articulation articulation x))
    (ly:music-property mus 'elements))
   ; (display-scheme-music mus)
   mus
)

%-------- Right Hand parts

RHpatternA = \relative c'' { % bar 3 first 3 quartet sans first rest
  <bes bes'>16-> <d f>4->~ q8. <bes bes'>16->
}

RHpatternB = \relative c'' { % bar 3 last quartet + bar 4
  \addArticulation "accent" {
    \moveTupletAbs 5 ##f \tuplet 6/4 {
      <d f>16 <a a'> <bes d> <g g'> <bes d> <f f'>
    } |
    \moveTupletAbs 3 ##f \tuplet 6/4 { <bes d>4 q16 q }
    q8. <f d bes f>16
  }
  \tuplet 3/2 { <f d bes f>16->( bes d) } <f d bes f>8->~
  \moveTupletAbs 5 ##f \tuplet 6/4 { q4~ q16 <g ees bes g>-> }
}

RHpatternC = \relative c'' { % bar 5
  \addArticulation "accent" {
    <f d bes f>8. <bes, bes'>16 <d f>4~ q8. <bes bes'>16
  }
  \moveTupletAbs 4 ##f \tuplet 6/4 {
    <d f>16-> <a a'> <bes d> <g g'> <bes d> <f f'>
  }
}

RHpatternD = \relative c'' { % bar 6
  \moveTupletAbs 3 ##f \tuplet 6/4 { <bes d>8.-> q16 q q }
  q8.-> <f d bes f>16->
  \tuplet 3/2 { <f d bes f>16->( bes d) } <f d bes f>8->~
  \moveTupletAbs 5 ##f \tuplet 6/4 { q4~ q16 <g d bes g>-> }
}

RHpatternE = \relative c'' { % bar 7
  \moveTupletAbs 5 ##f \tuplet 6/4 { <f d a f>4->~ q16 <d d'>-> }
  \moveTupletAbs 5 ##f \tuplet 6/4 { <f a>16-> <c c'> <d f> <bes bes'> <d f> <a a'> }
  \tuplet 6/4 { <c f>4~ q16 <a a'> }
  <c f>8 \tuplet 3/2 { <a f a,>16 q q }
}

RHpatternF = \relative c'' { % bar 8
  \moveTupletAbs 3 ##f \tuplet 6/4 { q4~ q16 <d d'>-> }
  \hideTupletOnce \tuplet 6/4 { <f a>16-> <c c'> <d f> <bes bes'> <d f> <a a'> }
  \hideTupletOnce \tuplet 6/4 { <c f>4~ q16 <a a'> }
  \hideTupletOnce \tuplet 6/4 { <c f>4~ q16 <f f'>-> }
}

RHpatternG = \relative c'' { % bar 9
  \addArticulation "accent" {
    <d~ f aes d~>4 <d e g d'>8. <c c'>16
    \moveTuplet -0.5 \tuplet 6/4 { <a ees' a>4~ q16 <g g'> }
    \moveTuplet -2   \tuplet 6/4 { <ees ees'>4~ q16 <d d'> }
  }
}

RHpatternH = \relative c' { % bar 10
  \addArticulation "accent" {
    \tuplet 3/2 { <bes bes'>16 <a a'> <g g'> } <f f'>8~
    \moveTupletAbs 3 ##f
    \once \override TupletNumber.extra-offset = #'(-2 . 0)
    \tuplet 6/4 { q4~ q16 \clef bass <f a ees' f> }
  }
}

RHpatternI = \relative c' { % bar 11
  \addArticulation "accent" {
    \moveTuplet -0.5     \tuplet 6/4 { <d bes f d>4~ q16 \clef treble <bes' bes'> }
    \moveTuplet -1.5     \tuplet 6/4 { <d f>4~ q16 <bes bes,>16 }
    \moveTupletAbs 3 ##f \tuplet 6/4 { <f d f,>4~ q16 <bes bes'> }
  }
}

RHpatternJ = \relative c' { % bar 13 + 14
  \addArticulation "accent" {
    \moveTuplet -1       \tuplet 6/4 { <f bes d f>4~ q16 <bes bes'> }
    <d f>8               \tuplet 3/2 { <bes bes,>16 q q } 
    \moveTupletAbs 3 ##f \tuplet 6/4 { <f d f,>4~ q16 <bes bes'> }
  }
  \hideTupletOnce  \tuplet 6/4 { <d f>16-> <a a'> <bes d> <g g'> <bes d> <f f'> } |
  <bes d>8         \tuplet 3/2 { q16 q q } q8.-> <f d bes f>16
                   \tuplet 3/2 { <f d bes f>16( bes d) } <f d bes f>8~
  \moveTuplet -0.5 \tuplet 6/4 { q4~ q16 <g d bes g>-> }
}

RHpatternK = \relative c' { % bar 15 + bar 16 first 3 quartet
  <f a d f>8->  \tuplet 3/2 { <a f d a>16 ( d f ) }
  \moveTuplet -1 \tuplet 6/4 { <a f d a>4->~ q16 <bes f des bes>-> }
  \stemUp <a f c a>8-> \tuplet 3/2 { <c, a f c>16 ( f a ) } \stemNeutral
  \addArticulation "accent" {
    \moveTuplet -1 \tuplet 6/4 { <c a f c>4~ q16 <ees c fis, ees> } |
    \moveTuplet -0.5 \tuplet 6/4 { <d bes g d>4~ q16 <c fis, ees c> }
    \tuplet 6/4 { <bes g d bes>4~ q16 <g ees c g> }
    \tuplet 3/2 { <f d bes f>8 <ees c ees,> <d bes d,> }
  }
}

RH = \relative c'' {
  \tupletUp
  \hideDynamics R1\ff | R1 |
  r8. \RHpatternA \RHpatternB |
  \RHpatternC |
  \RHpatternD |
  \RHpatternE |
  \RHpatternF |
  \RHpatternG |
  \RHpatternH |
  
  \barNumberCheck 11
  \RHpatternI \RHpatternB |
  \RHpatternJ |
  \RHpatternK
  \addArticulation "accent" {
    \moveTupletAbs 5 ##f \tuplet 5/4 {
      <bes d e bes'>16 <a cis e a> <f a d f> <d f bes d> <g bes ees g>
    }
  } |
  <f~ bes d f~>4-> <f a ees' f>8. <f f'>16-> |

  \barNumberCheck 18
  <<
    \relative c''' {
      \stemDown
      \showTupletTemp \tupletDown
      \moveTupletAbs -3 ##f
      \tuplet 6/4 { r16 <bes bes'> \( <d f> <a a'> <d f> <g, g'> }
      \moveTupletAbs -3 ##f
      \tuplet 6/4 { <bes d> <f f'> <bes d> <g g'> <bes d> <f f'> }
      \revertTuplet \tupletNeutral \hideTupletTemp
      \tuplet 6/4 4 {
        bes <d d,> bes <f f'> bes <d d,>
        bes <c c,> bes <d d,> f, <bes bes,> \)
      }
      \stemNeutral
    } \\
    \relative c' { <d f bes d>1-> }
  >> |
  
  \barNumberCheck 19
  \revertTuplet \hideTupletTemp
  \tuplet 6/4 4 {
    % bar 19
    r16 <d' d'> \( <f bes> <f f'>  <bes d> <d d,>
    <bes f> <c c,> <bes f> <d d,>     f,   <bes bes,>
    d,      <g g,> d       <bes bes'> d    <g g,>
    bes,    <f f'> bes     <ees ees,> bes  <d d,> |
    
    % bar 20
    <des bes ges des>\noBeam \)
    <ges ges'> \(        <bes des> <f f'>     <bes des> <ees ees,>
    <bes ges> <des des,> <bes ges> <ees ees,> <bes ges> <des des,>
    ges,      <bes bes,> ges       <des des'> ges       <bes bes,>
    des,      <aes aes'> des       <bes bes'> des       <ges ges,> \) |
    
    % bar 21
    r <des des'> \( <f bes> <f f'>   <bes des> <des des,>
    <bes f>  <c c,> <bes f> <des des,> <bes f> <c c,>
    f,   <bes bes,> f       <des des'> f       <bes bes,>
    des, <ges ges,> des     <bes bes'> des     f \) |
    
    % bar 22
    r        <des des'> \( <ges bes> <ees ees'> <ges bes> <des des'>
    ges         <bes bes,> ges       <c c,>     ges       <des des'> \)
    \ottavaUp
    <aes' c> \( <ees ees'> <aes c>   <f f'>     <aes c>   <ges ges'>
    <c ees>     <ges ges'> <c ees>   <aes aes'> <c ees>   <bes bes'> \) |
    
    % bar 23
    <des f> \( <bes bes'> f'  <c c'>     f    <des des'>
    f          <c c'>     f   <bes bes,> f    <aes aes,>
    des,       <ges ges,> des <f f,>
    \ottava #0 aes, <ees ees'>
    
    aes 16 <ees ees'> aes <des des,>
    \set tieWaitForNote = ##t
    des,_~ <f f,> |
    <fes des fes,>\noBeam \)
    \set tieWaitForNote = ##f
    
    % bar 24 sans first note
    <ees ees'>16 \(      <aes des> <fes fes'> <aes des> <ees ees'>
    <aes des> <fes fes'> <aes des> <ges ges'> <aes des> <fes fes'>
    aes       <ees ees'> aes       <fes fes'> aes       <ees ees'>
    g         <des des'> g         <ces ces,> g         <bes bes,> \) |
    
    % bar 25
    <aes ees> \( <bes bes,> <aes ees> <ces ces,> <aes ees> <bes bes,>
    ees,         <g g,>     ees       <aes aes,> ees       <bes bes'>
    <aes' ees>   <ces ces,> <aes ees> <bes bes,> <aes ees> <ces ces,>
    aes          <bes bes,> aes       <ces ces,> aes       <des des,> \) |
    
    % bar 26
    <ces aes> \( <d d,> <ces aes> <ees ees,> <ces aes> <e e,>
    <aes, ces>   <f f'> <aes ces> <e e'>     <aes ces> <f f'>
    <bes aes>    <d d,> <bes aes> <ees ees,> <bes aes> <e e,>
    <d bes>      <f f,> <d bes>
    \ottavaUp
    <ges ges,> <aes aes,> <bes bes,> \) |
    
    % bar 27
    <ges ees> \( <ees ees'> <ges bes> <ces ces,> <ges ees> <bes bes,>
    <ges ees>    <ces ces,> <ges ees> <bes bes,> <ges ees> <aes aes,>
    ees          <ges ges,> ees       <aes aes,>  ees      <ges ges,>
    \ottava #0
    bes,         <f f'>     bes       <ees, ees'> ges      <bes bes,> \) |
  
    % bar 28
    r     <b, eis  >(  eis,)  <b' fis' >(  fis  <fis ais>)
    b, (  <gis' b  >)  dis (  <b' dis  >)  e,(  <b' e   >)
    gis(  <dis' gis>)  ais (  <dis ais'>)  b (  <dis b' >
    b  )  <e ais   >(  ais,)  <e' b'   >(  b )  <e cis' >( |
    
    % bar 29
    cis )  <ees a   >(  a,  )  <ees' bes'>(  bes    <bes d   >)
    ees,(  <ces' ees>)  g   (  <ees' g   >)  aes,(  <aes' ees>)
    r      <ges ces >(  ces,)  <ges' des'>(  des )  <ges ees'>(
    ees )  <bes' ees>(  ees,)  <bes' f'  >(  f   )  <bes ges'>(
    
    % bar 30
    fis16) <a    dis eis>( eis) <a    dis fis>( fis) <dis fis ais>(
    ais  ) <dis  fis b  >( b  ) <fis' b   d  >( d  ) <fis b   dis>(
    dis  ) <ais' dis eis>( eis) <ais  dis fis>( fis) <dis fis a  >(
    a    ) <dis  fis ais>( ais) <fis' ais d  >( d  ) <fis ais dis> |
    
    % bar 31
    dis \repeat unfold 3 { <ais' e'>( e) <ais eis'>( eis) <ais e' fis>( fis) }
    <ais eis'>( eis) <ais fis'>( fis) <g bes e g>\noBeam-> |
    
    % bar 32
    \revertTuplet \showTupletTemp
    \addArticulation "accent" {
      <e g bes e>4~ q16 <d g bes d>
      <c g' bes c>4~ q16 <a c e a>
     <g c e g>8 <e bes' e>16 <d bes' d>8 <c bes' c>16
    }
    % SPECIAL NOTE: hiding tuplet numbers here and on next bar, unlike both
    % public domain editions. Repetitive.
    \revertTuplet \hideTupletTemp
    <c a'>-> ( g' e d c ) <g' bes e g>\noBeam-> |
    
    % bar 33
    \addArticulation "accent" {
      <e g bes e>4~ q16 <d g bes d>
      <c g' c>4~ q16 <a c a'>
      % FIXME Gutheil and Muzyka edition disagree here:
      % Gutheil: <e bes' e>
      % Muzyka: <e c' e>
      % sadly I don't have access to authentic version (Boosey & Hawkes)
      <g c g'>8 \clef bass <e c' e>16
      <d bes' d>8 <c bes' c>16
    }
    <c a'>-> ( g' e d c ) g'32[ ( d] |
  }
  \revertTuplet
  
  \barNumberCheck 34
  ees32 c d g, a f )              <g' ees' g>16->\noBeam q8.-> c32 ( g
  a    f g d ees c ) \clef treble <c' ees c'>16->\noBeam q8.-> g'32 ( d |
  ees32 c d g, a f )              <g' ees' g>16->\noBeam q8.-> c32 ( g
  a    f g d ees c )              <c' ees c'>16->\noBeam q8.-> c32 ( g |
  a    f g d ees c ) g'' ( d ees c d g, a f ) c'' ( g
  \repeat unfold 3 { a f c' g } a f ) r16 |
  
  \barNumberCheck 37
  \cadenzaOn \voiceOne
  \graceStyle
  \scaleDurations 3/4 { ees'16[ ( d }
  \scaleDurations 1/2 {
    c bes a g f ees d c bes a g f ees d]
    c[ \clef bass bes a g f ees d c bes a g f ees d c] )
  }
  \noGraceStyle
  \cadenzaOff \oneVoice |

  % bar 38
  \tupletUp
  r8. \clef treble \RHpatternA \RHpatternB |
  \RHpatternC |
  \RHpatternD |
  \RHpatternE |
  \RHpatternF |
  \RHpatternG |
  \RHpatternH |
  
  \barNumberCheck 46
  \RHpatternI \RHpatternB |
  \RHpatternJ |
  \RHpatternK
  \tuplet 5/4 { <g''' ees' g>16 <f d' f> <d bes' d> <bes d bes'> <ees c' ees> } |

  \tuplet 6/4 4 {
    <d bes' d   > <bes' d e bes'> <a cis e a > <f a d f    > <d f bes d> <g bes ees g>
    <f bes d f  > <ees' c' ees  > <d bes' d  > <bes d bes' > <g bes g' > <c ees c'>
    <bes d bes' > <a d a'       > <bes d bes'> <e, g cis e > <a c fis a> <d, f b d>
    <g bes ees g> <c, ees a c   > <f aes d f > <ees g c ees> <c g' c   > <g' bes c g'>
  } |
  
  <c,~ f bes c~>4-> <c ees a c>8. <d f bes d>16-> |
  
  \barNumberCheck 54
  \revertTuplet \hideTupletTemp
  <<
    \relative c'''' {
      \set subdivideBeams = ##t
      \voiceOne r8
      \voiceTwo
      % in referenced editions, ottava bracket collides w/ slur to save space
      % not sure if we need that here (and not sure whether it's achievable)
      \ottavaUp
      \once \phrasingSlurUp
      \tuplet 5/4 8 { d32 \( ees d c d g f d c bes f' d c bes g }
    }
    \new Voice \relative c'{
      \voiceTwo
      <d f bes d>2->
    }
  >>
  \oneVoice
  \tuplet 5/4 8 { d'''32 c bes g f g f d c bes }
  \ottava #0
  \tuplet 5/4 { f' d c bes g }
  \tuplet 6/4 { a bes b c ees ges } |
  
  % bar 55
  <f d>8\noBeam \)
  \ottavaUp
  \tuplet 5/4 8 { f32 \( g f e f bes g f ees d g f d c bes }
  \ottava #0
  \tuplet 5/4 8 { f' d c bes g d' c bes g f ees d c ees f }
  \tuplet 6/4 { ges aes a b c ees } |
  
  % bar 56
  <bes d>8\noBeam \)
  \tuplet 5/4 8 {
    bes32 \( c bes a bes d c bes g f bes g f ees d
    g f d c bes f' d c bes g d' c bes g f
  }
  \tuplet 6/4 { a bes b c ees ges } |
  
  % bar 57
  \showTupletOnce
  \tuplet 3/2 {
    <d f>16 \) r
    % for default value of max-ratio (3), end points will stick close to
    % note heads, therefore slur will have large curvature
    \once \override PhrasingSlur.details.head-slur-distance-max-ratio = #4
    \once \override PhrasingSlur.height-limit = #4
    c\noBeam \(
  }
  \tuplet 5/4 8 { d32 c bes g f bes g f ees d }
  \tuplet 6/4 { ees ges a b c ees }
  \showTupletOnce
  \tuplet 3/2 { <bes d>16 \) r f\noBeam \( }
  \tuplet 5/4 8 { bes32 g f ees d f ees d c bes }
  \tuplet 6/4 { a bes b c ees ges \) } |
  
  \barNumberCheck 58
  \set subdivideBeams = ##f
  <f d>8 r16 <bes bes,>16-- <f d>4--~
  \tupletUp \showTupletOnce \moveTupletAbs 3 ##f
  \tuplet 6/4 { q4~ q16 <d d'>-> }

  \addArticulation "accent" {
    <f bes>4~ |
    \tuplet 6/4 4 {
                 q4~ q16 <f f'      >
      <d bes' d  >4~ q16 <bes' bes' >
      <f' d f,   >4~ q16 <d d'      >
      <bes g' bes>4~ q16 <f' bes d f>
    }
  } |
  
  <d f bes d>16->\noBeam <bes' d f bes> <f bes d f> <g g'>
  <d d'> <f f'> <bes, bes'> <d d'>
  <g, g'> <bes bes'> <f f'> <g g'>
  <d d'> <f f'> <bes, bes'> <d d'> |
  
  <<
    { r4 <a' c ees a>-> r8 \clef treble <bes d f bes>4.->\fermata } \\
    \relative c { <f f'>2-> \clef bass bes,-> }
  >> \bar "|."

}


%-------- Left Hand parts
LHnotesA = \relative c, {
  \moveTupletAbs -3 ##f  % 2nd tuplet position is ok
  \once \override PhrasingSlur.eccentricity = 2
  \tuplet 6/4 4 {
    \tag #'accents <bes bes,>16 \( f' bes d e f
    <bes d> g f d bes f\)
  }
}

LHpatternA = % bar 1, 1st half
#(define-music-function (parser location tup-visible) (boolean?)
   #{ \toggleTup #tup-visible \LHnotesA #} )

LHnotesB = \relative c, {
  \moveTupletAbs -3 ##f  % 2nd tuplet position is ok
  \once \override PhrasingSlur.eccentricity = 2
  \tuplet 6/4 4 { bes16\( f' bes d e f <bes d> g f d bes f\) }
}

LHpatternB = % bar 1, 2nd half
#(define-music-function (parser location tup-visible) (boolean?)
   #{ \toggleTup #tup-visible \LHnotesB #} )

LHnotesC = \relative c, {
  \tuplet 6/4 4 {
    bes16 \(  f' bes d e f <bes d> f d bes f bes,~ |
    bes \)
    % right end point can't reach note when slope factor >= 5 (2.18.x)
    % even 3 won't make it (2.19.x)
    \once \override PhrasingSlur.details.steeper-slope-factor = #2
    \once \override PhrasingSlur.eccentricity = 2
    f' \( bes d e f <bes d> g f d_1 bes_2 f_3 \)
  }
}

LHpatternC = % bar 3 2nd half + bar 4 1st half
#(define-music-function (parser location finger-visible) (boolean?)
   #{ \toggleFinger #finger-visible \LHnotesC #})

LHpatternD = \relative c, { % bar 4 or bar 6, 2nd half
  \tuplet 6/4 4 {
    \hideTupletOnce <f bes,>16\( bes d
    \tag #'(accents end-ees end-d) <f> bes, d
    \showTupletOnce f bes d f8\)
    \tag #'end-ees <ees bes g>16->
    \tag #'end-d   <d   bes g>16->
  }
}

LHnotesF = \relative c {
  \tuplet 6/4 4 {
    <a d,>16 \( d_1 f
    \once \override Fingering.avoid-slur = #'ignore
    \once \override Fingering.extra-offset = #'(0 . 2)
    \once \override Fingering.whiteout = ##t
    a_1 gis a \)
    r f'_1 ( d f, ) f_1 ( d )
  }
}

LHpatternF = % bar 7, 1st half
#(define-music-function (parser location finger-visible) (boolean?)
   #{ \toggleFinger #finger-visible \LHnotesF #} )

LHnotesG = \relative c {
  \tuplet 6/4 4 {
    <c f,>16 \( f_1 a c_1 b c \)
    r c_1 \( a f c_1 bes \)
  }
}

LHpatternG = % bar 7, 2nd half
#(define-music-function (parser location finger-visible) (boolean?)
   #{ \toggleFinger #finger-visible \LHnotesG #} )

LHpatternH = \relative c { % bar 8, 2nd half
  \hideTupletTemp
  \tuplet 6/4 4 { <c f,>16\( f a c b c\) r c\( a f c c,\) }
  \revertTuplet
}

LHpatternI = \relative c { % bar 9, 1st half
  \hideTupletOnce \tuplet 6/4 {
    \once \override PhrasingSlur.details.region-size = #6
     % discourage steep slope around end-points
    \once \override PhrasingSlur.details.edge-slope-exponent = #5
    c16\( aes'_3 b d_1 e_2 f_1
  }
  <e bes g>8.\) <f,, f,>16->
}

LHpatternJ = \relative c { % bar 9, 2nd half
  \once \stemDown <ees a>8->
  \showTupletOnce \tuplet 3/2 { <c f,>16 ( ees g-> ) }
  \showTupletOnce \moveTupletAbs -3 ##f \tuplet 6/4 { ees4->~ ees16 d-> }
}

LHpatternK = \relative c { % bar 10
  \addArticulation "accent" {
    \tuplet 3/2 { bes16 a g } f8~
    \moveTupletAbs #-4.5 ##f
    \once \override TupletNumber.extra-offset = #'(-2 . 0)
    \tuplet 6/4 { f4~ f16 <f f,> }
  }
}

LHpatternL = \relative c { % bar 15 + bar 16 first half
  \set subdivideBeams = ##t
  % move tuplet number away from slur
  \once \tupletUp \tuplet 3/2 { <a d,>16 ( d f ) } r8
  \hideTupletOnce \tuplet 6/4 { <a, d,>16 ( d f ) f ( a <bes des,>-> }
  % NOTE: In both Gutheil and Muzgiz editions, there is no slur on
  % first occurance of { <f c'>16 a'8 }, but slur exists on 2nd occurance
  \once \tupletUp \tuplet 3/2 { <a c,>8-> ) <c, f,>16 ( } a'8 )
  \hideTupletOnce \tuplet 6/4 { <c, f,>16 ( f a ) a ( c <ees fis,>-> } |

  \unset subdivideBeams
  \addArticulation "accent" {
    \tuplet 6/4 { <d bes g>4~ q16 ) <a c fis> }
    \moveTupletAbs -3.5 ##f \tuplet 6/4 { <bes d g>4~ q16 <a ees c> }
  }
}

%%% LHpatternA/B (tuplet-visible)
%%% LHpatternC/F/G (fingering-visible)
%%% \pushToTag #'accents -> \LHpatternA/D   (accent on certain note)
%%% tags #'end-ees and #'end-d control which last note to use on patternD

LH = \relative c'
{
  \tupletDown
  \LHpatternA ##t \LHpatternB ##t |
  \LHpatternA ##f \LHpatternB ##f |
  \LHpatternA ##f \LHpatternC ##t
  \pushToTag #'accents -> \keepWithTag #'end-ees \LHpatternD |
  \LHpatternA ##f \LHpatternC ##f
  \pushToTag #'accents -> \keepWithTag #'end-d   \LHpatternD |
  \LHpatternF ##t \LHpatternG ##t |
  \LHpatternF ##f \LHpatternH |
  \LHpatternI     \LHpatternJ |
  \LHpatternK |

  \barNumberCheck 11
  \pushToTag #'accents -> \LHpatternA ##f
  \LHpatternC ##f \keepWithTag #'end-ees \LHpatternD |
  \LHpatternA ##f
  \LHpatternC ##f \keepWithTag #'end-d   \LHpatternD |
  \LHpatternL
  \showTupletTemp
  \addArticulation "accent" {
    \tuplet 3/2 { <bes f d>8 <f f,> <fis fis,> }
    \tuplet 5/4 { <g g,>16 <a a,> <d, d,> <bes' bes,> <ees, ees,> }
  } |
  \revertTuplet
  <f f,>4-> <f a ees'>8. <bes,, bes,>16-> |

  \barNumberCheck 18
  <<
    \relative c, {
      % bar 18-21
      r16 <f bes,>^\( bes d
      \showTupletTemp
      \moveTupletAbs 0 ##t \tuplet 3/2 { f8 bes d }
      \moveTupletAbs 1 ##t \tuplet 3/2 { f d bes }
      \revertTuplet \hideTupletTemp
      \tuplet 3/2 { f d bes \) } |
      s2. f'4-- |
      <ges bes,>2.-- aes8--
      % 2nd part of broken tie is way too short
      \shape #'(() ((0 . 2)(0.8 . 2.5)(1.6 . 2.5)(2.4 . 2))) Tie
      bes--~ |
      <des bes f>2.-- ees8-- <f bes,>-- |
      
      % bar 22-23
      <ges~ des bes ees,>2--\arpeggio
      \tuplet 3/2 { ges4 aes8-- }
      \clef treble <bes>8--\arpeggio c-- |
      \clef bass <des f, aes, f aes, des,>4.--\arpeggio s8*1/3 c8*2/3--
      bes8-- ( aes-- f-- )
      % first part of broken slur has bad end point
      \shape #'(((0 . 0)(0 . 0)(0 . 2)(0 . 2)) ()) Slur
      \clef bass g,-- ( |
      
      % bar 24-27
      <aes fes aes, des,>2\arpeggio )
      bes8--[ ( ces--] des--\arpeggio [ ees--] |
      <ces ees, aes,>2.-- )
      % 2nd part of broken slur is ugly, bad end point
      \shape #'(() ((0 . -0.5)(0 . -0.5)(0 . 1.5)(0 . 1.5))) Slur
      d8-- ( ees-- |
      <f~ ces aes>2 f4*2/3 ) ges8*2/3-- ( aes8-- bes-- ) |
      <ges bes, ges bes, ees,>1--\arpeggio |
    } \\
    \relative c {
      % bar 18-21
      <f d bes f>1-> |
      \hideTupletTemp
      \tuplet 3/2 4 { <f, bes,>8 ( bes d f bes d r d, bes f bes, f' ) } |
      \tuplet 3/2 4 { r8 bes, ( bes' ges' des' ges des ges, bes, ) } r4 |
      \tuplet 3/2 4 { r8 bes, ( bes' f' bes c des bes <f bes,> ) } r4 |
      
      % bar 22-23
      \tuplet 3/2 4 { r8 ees, ( bes' ges' bes des ) }
      \showTupletOnce
      % manually ignore tuplet stuff so slur is drawn at natural position
      \once \override TupletNumber.avoid-slur = #'outside
      \tuplet 3/2 { <c aes ges>8 ( aes, ) aes'' } <ees c ges>4\arpeggio |
      \tuplet 3/2 4 { r8 aes,, ( f' des' \clef treble f ) c' }
      des,4~ des8 r |
      
      % bar 24
      \tuplet 3/2 4 { r8 des,, ( aes' fes' aes fes' ) }
      r4 <ees,, des' g>4\arpeggio |
      
      % bar 25
      \tuplet 3/2 4 { r8 aes, ( aes' ees'4 ) aes,8 ( ces' ees, aes, ) }
      % SPECIAL NOTE: Both Muzyka and Gutheil editions don't show any accidentals,
      % which implies A♮ here. However, A♮ here is odd since the tonality
      % for left hand on this bar is mostly A♭m.
      % Checked a few performances with sound frequency analysis, none of them
      % is A♮:
      % Richter, Ashkenazy: A♭
      % Ogdon, Gilels: B♮
      <ees' aes>4 |
      
      % bar 26
      \tuplet 3/2 4 {
        r8 aes, ( f' ces' f, ces' )
        <aes bes d> bes, ges''
      }
      <aes, bes d>4 |
      
      % bar 27
      \tuplet 3/2 4 {
        r8 ees,, ( ees' bes' ges' bes
        ges' bes, ges bes, ees, bes' )
      }
    }
  >> |
  
  \barNumberCheck 28
  <<
    \relative c' {
      \mergeDifferentlyDottedOn
      b8. a16 gis4 dis' cis8. b16 |
      bes4 ces ges'4. f16( ees)
    } \\
    \relative c' {
      b16 ( b, dis, ) a'' gis ( b, e, b' )
      dis' ( b gis dis ) cis' ( e, fis, ) b' |
      bes16 ( ees, g, ees' ) ces' ( ees, aes, ees' )
      \shape #'((0 . 0) (0 . 0) (0 . 0) (0 . 1)) Slur
      ges' ( ees ces ges bes, ges' ) f' ees
    }
  >> |
  
  % bar 30-31
  \revertTuplet \showTupletTemp
  \tupletNeutral
  \tuplet 3/2 { <dis'' a fis b,>8\arpeggio \clef treble b'16-> ( }
  \addArticulation "accent" {
    fis8\noBeam~
    \tuplet 6/4 { fis8 ) dis16 ( b8 ) \clef bass fis16 }
    \tuplet 3/2 { <dis bis>8 \clef treble ais''16 ( } fis8\noBeam~
    \tuplet 6/4 { fis8 ) \clef bass dis16 ( ais8 ) fis16 ( } |
    \tuplet 3/2 { <e cis>8 ) ais'16 ( } fis8\noBeam~
    \tuplet 6/4 { fis8 ) <e e,>16 <cis cis,>8 <ais ais,>16 }
    \revertTuplet \hideTupletTemp
    \tuplet 6/4 {
      <fis fis,>8 <e e,>16 <cis cis,>8 <ais ais,>16
      % SPECIAL NOTE: currently no public domain editions has ottava.
      % it may save a bit of vertical space... or not.
      % \ottava #-1 \set Staff.ottavation = #"8"
      <fis fis,>8 <e e,>16 <cis cis,>8 c,16
      % \ottava 0
    }
  }

  % bar 32
  % Accent is too far away? But slur curve depends on automatic
  % layout and note density, so there's no reliable way of placing accent
  \tuplet 6/4 { c'16-> ( g'' bes e f g } <bes, e>8 )
  \revertTuplet \showTupletTemp
  \tuplet 3/2 { a16 ( g c, }
  \tuplet 6/4 { <g' bes>8 ) <g bes>16-> <f bes>8-> <e bes'>16-> }
  <c bes'>8->\noBeam
  
  % bar 33
  \tuplet 3/2 { d16 ( c g ) } |
  \revertTuplet \hideTupletTemp
  \tuplet 6/4 { c, ( g' c e f g }
  <bes, e>8 ) \tuplet 3/2 { a16 ( g c, }
  \tuplet 6/4 { <g' bes>8 ) <g bes>16-> <f bes>8-> <e bes'>16-> }
  \revertTuplet <c bes'>4-> |
  
  % bar 34-36
  f,8. g'32 ( d ees c d g, a f~ f16 )
  % SPECIAL NOTE: slur end point is suspicious, maybe should end one note
  % earlier -- on these bars all slur covers 8 notes except this one
  ees''8.-- c32 ( g a f g d ees c <f f,>16-> ) |
  <ees' g>8.-> g32 ( d ees c d g, a f ) ees'16->\noBeam
  ees'8.->\noBeam c32 ( g a f g d ees c ) c' ( g |
  a f g d ees c ) g'' ( d ees c d g, a f ) \clef treble c'' ( g
  \repeat unfold 3 { a ees c' g } a ees ) r16 \clef bass |
  
  % bar 37
  \cadenzaOn
  \graceStyle
  \change Staff="RH" \voiceTwo
  \scaleDurations 3/4 { ees'16[ ( d }
  \scaleDurations 1/2 { c bes a g] ) }
  \scaleDurations 3/4 { f8[ ( ees } f,] )
  \change Staff="LH" \oneVoice
  \scaleDurations 3/4 { f[ ( ees f,] ) f[( f,]) }
  \noGraceStyle
  \cadenzaOff \bar "|"
  
  \barNumberCheck 38
  \tupletDown
  \LHpatternA ##f \LHpatternC ##f
  \pushToTag #'accents -> \keepWithTag #'end-ees \LHpatternD |
  \LHpatternA ##f \LHpatternC ##f
  \pushToTag #'accents -> \keepWithTag #'end-d \LHpatternD |
  \LHpatternF ##t \LHpatternG ##t |
  \LHpatternF ##f \LHpatternH |
  \LHpatternI     \LHpatternJ |
  \LHpatternK |
  
  \barNumberCheck 46
  \pushToTag #'accents -> \LHpatternA ##f
  \LHpatternC ##f \keepWithTag #'end-ees \LHpatternD |
  \LHpatternA ##f
  \LHpatternC ##f \keepWithTag #'end-d   \LHpatternD |
  \LHpatternL
  \tuplet 3/2 { <d'' f bes>8-> <fis fis,>-> <g g,>-> }
  \tuplet 5/4 { <c, c,>16 <d d,> <fis fis,> <g g,> <a a,> } |

  \revertTuplet \hideTupletTemp
  \tuplet 6/4 4 {
    <bes bes,> <g g,> <a a,> <d, d,> <bes bes'> <ees ees,>
    <f f,> <fis fis,> <g g,> <d d'> <ees ees'> <a a,>
    <bes bes,> <fis fis,> <g g,> <a a,> <d, d,> <g g,>
    <c, c,> <f f,> <b, b,> <c c,> <ees ees,> <e e,>
  } |
  
  <f f,>4-> <c ees a>8. <bes, bes,>16-> |
  
  \barNumberCheck 54
  <<
    \relative c { \voiceTwo r8 \once \phrasingSlurUp f \( bes d }
    \new Voice \relative c { \voiceOne <f d bes f>2-> }
  >>
  \oneVoice
  \clef treble f'''8 bes4 <c ges ees>8 |
  
  % bar 55
  <d f, bes,>8\noBeam \)
  \clef bass \once \phrasingSlurUp <d,, f, bes,> \( f bes
  \clef treble d f4 <a ees c ges>8 |
  
  % bar 56
  <bes d, f,>8\arpeggio\noBeam \) \clef bass <f,, bes,> \( bes d
  f bes4 <c ges ees>8 |
  
  % bar 57
  <bes d, f,>8\arpeggio \) bes,,[ ( <f' d'>] ) <a' ees c>--[ (
  <bes d, f,>--] ) bes,,[ ( <f' d'>] )
  \once \override Beam.breakable = ##t
  <ees' ges>--[ |
  
  \barNumberCheck 58
  <f bes,>--]
  \tupletDown \revertTuplet \showTupletTemp
  \moveTupletAbs -3 ##f \tuplet 3/2 { <f, bes,>16 ( bes d }
  \moveTupletAbs -3 ##f \tuplet 6/4 { f d bes d bes f ) }
  \revertTuplet \hideTupletTemp
  \tuplet 6/4 4 { bes, ( f' bes d cis d f d bes d bes f ) } |
  
  % bar 59
  \tuplet 6/4 4 {
    bes, ( f' bes d cis d bes' d, bes d bes f )
    bes, ( f' bes d f ) r
    e, ( bes' d g bes ) <f d bes f>->\noBeam
  } |
  
  % bar 60
  <f bes d f>16->\noBeam <bes d bes'> <f bes d f> <g g'>
  <d d'> <f f'> <bes, bes'> <d d'>
  <g, g'> <bes bes'> <f f'> <g g'>
  <d d'> <f f'> <bes, bes'> <d d'> |
  
  <<
    \relative c { r4 <ees a c ees>-> r8 <d f bes d>4.->\fermata } \\
    \relative c, { <f f,>2-> <bes, bes,>-> }
  >>
}

Dynamics = {
  \tempo \markup{ \huge{ "Maestoso." } } 4 = 80

  s1\f |
  s1 |
  s8 s2..\ffmarcato |
  s1*5 |
  s2. s4\ff |
  \time 2/4 s2 |

  \barNumberCheck 11

  \time 4/4 s1\ff |
  s1*5 |
  \time 2/4 s2 |
  \time 4/4 s1\ff |
  s2._\dim s4\p |
  s1 |
  
  \barNumberCheck 21

  s2. s4\< |
  s2\! s4*5/3\> s4*1/3\! |
  \once \override DynamicText.X-offset = #-2
  s1\p |
  s2 s8\< s8\! s8\> s8\! |
  s2 s4*2/3 s4*4/3\< |
  s1\! |
  \once \override DynamicText.X-offset = #-4
  s1\pp |
  
  \barNumberCheck 28

  \once \override DynamicTextSpanner.text = "un poco cresc."
  \once \set crescendoSpanner = #'text
  s1\< |
  s2 s2\cresc |
  s8*2/3\f s4*2/3-\markup{\larger \italic "marcato"} s2. |
  s1 |
  s1\f |
  s2. s4*5/6\> s4*1/6\! |
  s2\p s2\cresc |
  s1 |
  s2... s16\! |
  
  \barNumberCheck 37
  \time 2/4 s1 | % inside \cadenza
  
  \set Score.currentBarNumber = #38 % \cadenza skips bar number, so increment manually
  \time 4/4
  s8 s2..\ffmarcato |
  s1*6 |
  \time 2/4 s2 |
  
  \barNumberCheck 46
  \time 4/4 s1\ff |
  s1*4 |
  s2. s4-\markup{\larger \italic "marcato"} |
  s1 |
  \time 2/4 s2 |
  
  \barNumberCheck 54
  \time 4/4
  s8 s2\ff  s8.\< s16\! s16*1/3 s16*4/3\> s16*1/3\! |
  s8 s2\dim s8.\< s16\! s16*1/3 s16*4/3\> s16*1/3\! |
  s8 s2     s8.\< s16\! s16*1/3 s16*4/3\> s16*1/3\! |
  s4. s8\> s4.\! s8\> |
  
  \barNumberCheck 58
  s2\p s2\cresc |
  s1 |
  s1\ff |
  s1
}

%-------Typeset music and generate midi
\score {

  \context PianoStaff <<
    \set PianoStaff.midiInstrument = "acoustic grand"
    % Make sure secondary beams are grouped per semiquaver, e.g.
    % in subdivideBeams, bar 30-32
    \set PianoStaff.baseMoment = #(ly:make-moment 1 8)
    % setting connectArpeggios in Staff context won't work
    \set PianoStaff.connectArpeggios = ##t
    %\accidentalStyle PianoStaff.piano
    \new Staff = "RH" << \clef treble \key bes \major \time 4/4 \RH >>
    \new Dynamics << \Dynamics >>
    \new Staff = "LH" << \clef bass   \key bes \major \time 4/4 \LH >>
  >>
  \layout {
    \context {
      \Score
      \omit TupletBracket
      \override TupletBracket.avoid-slur = #'ignore
      \override DynamicTextSpanner.style = #'none
    }
  }
  \midi {
    \tempo 4 = 80
    \context {
      \Score
      midiMinimumVolume = #0.3
      midiMaximumVolume = #1
    }
  }
}

