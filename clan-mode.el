;;; clan-mode.el --- sample major mode for editing CLAN. -*- coding: utf-8; lexical-binding: t; -*-

;; Copyright © 2020, by you

;; Author: Chas Threlkeld ( charles.threlkeld@tufts.edu )
;; Version: 0.0.1
;; Created: 11 03 2020
;; Keywords: languages
;; Homepage: http://ergoemacs.org/emacs/elisp_syntax_coloring.html

;; This file is not part of GNU Emacs.

;;; License:

;; You can redistribute this program and/or modify it under the terms of the GNU General Public License version 3.

;;; Commentary:

;; short description here

;; full doc on how to use here

;;; Code:

(defun insert-bullet ()
  "Symbolic wrapper for inserting a bullet."
  (interactive)
  (insert " " "•"))

(defun stop-player ()
  "Stops the running audio."
  (interactive)
  (delete-process "clan-ffplay"))

(defun cha-to-timestamp (cha)
  "Convert a CHA timestamp to a hh:mm:ss.mmm style timestamp."
  (let* ((timestamp (string-to-number cha))
	 (millis (format "%03d" (mod timestamp 1000)))
	 (seconds (format"%02d" (mod (/ timestamp 1000)
					 60)))
	 (minutes (format "%02d" (mod (/ timestamp 60000)
					 60)))
	 (hours (format "%02d" (/ timestamp 3600000))))
    (concat hours ":" minutes ":" seconds "." millis)))

(defun get-media ()
  "Get the relative location of the audio file associated with the clan file."
  (when (search-backward-regexp "^@Media:")
    (search-forward-regexp "[[:space:]]")
    (let* ((start-pos (point)))
      (search-forward-regexp "\\.[[:alnum:]]\\{3\\}")
      (let* ((end-pos (point)))
	(buffer-substring-no-properties start-pos end-pos))))
    ;; TODO: catch not-found error
    )

(defun play-line ()
  "Play media associated with line at point."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (search-forward "•")
    (let* ((start-pos (point)))
      (search-forward "_")
      (let* ((split-pos (1- (point))))
	(search-forward "•")
	(let* ((last-pos (1- (point)))
	       (cha-start-time (buffer-substring-no-properties start-pos split-pos))
	       (start-time (cha-to-timestamp cha-start-time))
	       (cha-end-time (buffer-substring-no-properties (+ 1 split-pos) last-pos))
	       (run-time (cha-to-timestamp (number-to-string (- (string-to-number cha-end-time)
								(string-to-number cha-start-time))))))
	  (start-process "clan-ffplay" "clan-ffplay" "ffplay" "-nodisp" "-autoexit"
			 "-ss" start-time
			 "-t" run-time
			 (concat default-directory (get-media))))))))

(defun play-from-line ()
  "Play media beginning with line at point."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (search-forward "•")
    (let* ((start-pos (point)))
      (search-forward "_")
      (let* ((split-pos (1- (point)))
	     (cha-start-time (buffer-substring-no-properties start-pos split-pos))
	     (start-time (cha-to-timestamp cha-start-time)))
	(start-process "clan-ffplay" "clan-ffplay" "ffplay" "-nodisp" "-autoexit"
		       "-ss" start-time
		       (concat default-directory (get-media)))))))
  
  
;; create the list for font-lock.
;; each category of keyword is given a particular face
(defvar clan-font-lock-keywords
      (let* (
	    (x-params-regexp "^@[A-Z]D?[a-z]*:?")
	    (x-speaker-regexp "^\*...:")
	    (x-timestamps-regexp "•[0-9]*_.[0-9]*•")
	    (x-tag-regexp "^%[a-zA-Z]*:"))
        `(
	  (,x-params-regexp . font-lock-type-face)
	  (,x-speaker-regexp . font-lock-constant-face)
	  (,x-timestamps-regexp . font-lock-builtin-face)
	  (,x-tag-regexp . font-lock-comment-face)
          ;; note: order above matters, because once colored, that part won't change.
          ;; in general, put longer words first
          )))

;; ------------------------------------------
;; Special Symbols


(defun insert-shift-high ()
  "Insert shift to high pitch."
  (interactive)
  (insert "↑"))

(defun insert-shift-low ()
  "Insert shift to low pitch."
  (interactive)
  (insert "↓"))

(defun insert-rising-high ()
  "Insert rising to high."
  (interactive)
  (insert "⇗"))

(defun insert-rising-mid ()
  "Insert rising to mid."
  (interactive)
  (insert "↗"))

(defun insert-level ()
  "Insert level."
  (interactive)
  (insert "→"))

(defun insert-falling-mid ()
  "Insert falling to mid."
  (interactive)
  (insert "↘"))

(defun insert-falling-low ()
  "Insert falling to low."
  (interactive)
  (insert "⇘"))

(defun insert-unmarked-ending ()
  "Insert unmarked ending."
  (interactive)
  (insert "∞"))

(defun insert-continuation ()
  "Insert continuation."
  (interactive)
  (insert "≋"))

(defun insert-inhalation ()
  "Insert inhalation."
  (interactive)
  (insert "∙"))

(defun insert-latching ()
  "Insert latching."
  (interactive)
  (insert "≈"))

(defun insert-uptake ()
  "Insert uptake."
  (interactive)
  (insert "≡"))

(defun insert-top-begin-overlap ()
  "Insert top begin overlap."
  (interactive)
  (insert "⌈"))

(defun insert-top-end-overlap ()
  "Insert top end overlap."
  (interactive)
  (insert "⌉"))

(defun insert-bottom-begin-overlap ()
  "Insert bottom begin overlap."
  (interactive)
  (insert "⌊"))

(defun insert-bottom-end-overlap ()
  "Insert bottom end overlap."
  (interactive)
  (insert "⌋"))

(defun insert-faster ()
  "Insert faster."
  (interactive)
  (insert "∆"))

(defun insert-slower ()
  "Insert slower."
  (interactive)
  (insert "∇"))

(defun insert-creaky ()
  "Insert creaky."
  (interactive)
  (insert "⁎"))

(defun insert-unsure ()
  "Insert unsure."
  (interactive)
  (insert "⁇"))

(defun insert-softer ()
  "Insert softer."
  (interactive)
  (insert "°"))

(defun insert-louder ()
  "Insert louder."
  (interactive)
  (insert "◉"))

(defun insert-low-pitch ()
  "Insert low pitch."
  (interactive)
  (insert "▁"))

(defun insert-high-pitch ()
  "Insert high pitch."
  (interactive)
  (insert "▔"))

(defun insert-smile-voice ()
  "Insert smile voice."
  (interactive)
  (insert "☺"))

(defun insert-breathy-voice ()
  "Insert breathy voice."
  (interactive)
  (insert "♋"))

(defun insert-whisper ()
  "Insert whisper."
  (interactive)
  (insert "∬"))

(defun insert-yawn ()
  "Insert yawn."
  (interactive)
  (insert "Ϋ"))

(defun insert-singing ()
  "Insert singing."
  (interactive)
  (insert "∮"))

(defun insert-precise ()
  "Insert precise."
  (interactive)
  (insert "§"))

(defun insert-constriction ()
  "Insert constriction."
  (interactive)
  (insert "∾"))

(defun insert-pitch-reset ()
  "Insert pitch reset."
  (interactive)
  (insert "↻"))

(defun insert-laugh-in-word ()
  "Insert laugh in a word."
  (interactive)
  (insert "Ἡ"))

(defun insert-final-particle ()
  "Insert tag or sentence final particle."
  (interactive)
  (insert "„"))

(defun insert-vocative ()
  "Insert vocative or summons."
  (interactive)
  (insert "‡"))

(defun insert-diacritic ()
  "Insert arabic dot diacritic."
  (interactive)
  (insert "̣"))

(defun insert-raised-h ()
  "Insert arabic raised h."
  (interactive)
  (insert "ʰ"))

(defun insert-stress ()
  "Insert stress."
  (interactive)
  (insert "̄"))

(defun insert-glottal-stop ()
  "Insert glottal stop."
  (interactive)
  (insert "ʔ"))

(defun insert-reverse-glottal ()
  "Insert reverse glottal."
  (interactive)
  (insert "ʕ̌"))

(defun insert-caron ()
  "Insert caron."
  (interactive)
  (insert "̌"))

(defun insert-raised-stroke ()
  "Insert raised stroke."
  (interactive)
  (insert "ˈ"))

(defun insert-lowered-stroke ()
  "Insert lowered stroke."
  (interactive)
  (insert "ˌ"))

(defun insert-length ()
  "Insert length on the %pho line."
  (interactive)
  (insert "ː"))

(defun insert-begin-phono-group ()
  "Insert begin phono group marker."
  (interactive)
  (insert "‹"))

(defun insert-end-phono-group ()
  "Insert end phono group marker."
  (interactive)
  (insert "›"))

(defun insert-begin-sign-group ()
  "Insert begin sign group."
  (interactive)
  (insert "〔"))

(defun insert-end-sign-group ()
  "Insert end sign group."
  (interactive)
  (insert "〕"))

(defun insert-pho-missing-word ()
  "Insert %pho missing word."
  (interactive)
  (insert "…"))

(defun insert-underline ()
  "Insert underline."
  (interactive)
  (insert "̲"))

(defun insert-open-quote ()
  "Insert open quote."
  (interactive)
  (insert "“"))

(defun insert-close-quote ()
  "Insert close quote."
  (interactive)
  (insert "”"))


;; --------------------------------------------
;; Keybinding

(defvar clan-mode-map nil "Keymap for `clan-mode.")
(setq clan-mode-map (make-sparse-keymap))
  
(define-key clan-mode-map [menu-bar clan-menu shift-high]
  '("↑ shift to high pitch" . insert-shift-high))
(define-key clan-mode-map [menu-bar clan-menu shift-low]
    '("↓ shift to low pitch" . insert-shift-low))
(define-key clan-mode-map [menu-bar clan-menu rising-high]
    '("⇗ rising to high" . insert-rising-high))
(define-key clan-mode-map [menu-bar clan-menu rising-mid]
    '("↗ rising to mid" . insert-rising-mid))
(define-key clan-mode-map [menu-bar clan-menu level]
    '("→ level" . insert-level))
(define-key clan-mode-map [menu-bar clan-menu falling-mid]
    '("↘ falling to mid" . insert-falling-mid))
(define-key clan-mode-map [menu-bar clan-menu falling-low]
    '("⇘ falling to low" . insert-falling-low))
(define-key clan-mode-map [menu-bar clan-menu unmarked-ending]
    '("∞ unmarked ending" . insert-unmarked-ending))
(define-key clan-mode-map [menu-bar clan-menu continuation]
    '("≋ ≋continuation" . insert-continuation))
(define-key clan-mode-map [menu-bar clan-menu inhalation]
    '("∙ inhalation" . insert-inhalation))
(define-key clan-mode-map [menu-bar clan-menu latching]
    '("≈ latching≈" . insert-latching))
(define-key clan-mode-map [menu-bar clan-menu uptake]
    '("≡ ≡uptake" . insert-uptake))
(define-key clan-mode-map [menu-bar clan-menu top-begin-overlap]
    '("⌈ top begin overlap" . insert-top-begin-overlap))
(define-key clan-mode-map [menu-bar clan-menu top-end-overlap]
    '("⌉ top end overlap" . insert-top-end-overlap))
(define-key clan-mode-map [menu-bar clan-menu bottom-begin-overlap]
    '("⌊ bottom begin overlap" . insert-bottom-begin-overlap))
(define-key clan-mode-map [menu-bar clan-menu bottom-end-overlap]
    '("⌋ bottom end overlap" . insert-bottom-end-overlap))
(define-key clan-mode-map [menu-bar clan-menu faster]
    '("∆ ∆faster∆" . insert-faster))
(define-key clan-mode-map [menu-bar clan-menu slower]
    '("∇ ∇slower∇" . insert-slower))
(define-key clan-mode-map [menu-bar clan-menu creaky]
    '("⁎ ⁎creaky⁎" . insert-creaky))
(define-key clan-mode-map [menu-bar clan-menu unsure]
    '("⁇ ⁇unsure⁇" . insert-unsure))
(define-key clan-mode-map [menu-bar clan-menu softer]
    '("° °softer°" . insert-softer))
(define-key clan-mode-map [menu-bar clan-menu louder]
    '("◉ ◉louder◉" . insert-louder))
(define-key clan-mode-map [menu-bar clan-menu low-pitch]
    '("▁ ▁low pitch▁" . insert-low-pitch))
(define-key clan-mode-map [menu-bar clan-menu high-pitch]
    '("▔ ▔high pitch▔" . insert-high-pitch))
(define-key clan-mode-map [menu-bar clan-menu smile-voice]
    '("☺ ☺smile voice☺" . insert-smile-voice))
(define-key clan-mode-map [menu-bar clan-menu breathy-voice]
    '("♋ ♋breathy voice♋" . insert-breathy-voice))
(define-key clan-mode-map [menu-bar clan-menu whisper]
    '("∬ ∬whisper∬" . insert-whisper))
(define-key clan-mode-map [menu-bar clan-menu yawn]
    '("Ϋ ΫyawnΫ" . insert-yawn))
(define-key clan-mode-map [menu-bar clan-menu singing]
    '("∮ ∮singing∮" . insert-singing))
(define-key clan-mode-map [menu-bar clan-menu precise]
    '("§ §precise§" . insert-precise))
(define-key clan-mode-map [menu-bar clan-menu constriction]
    '("∾ constriction∾" . insert-constriction))
(define-key clan-mode-map [menu-bar clan-menu pitch-reset]
    '("↻ ↻pitch reset" . insert-pitch-reset))
(define-key clan-mode-map [menu-bar clan-menu laugh-in-word]
    '("Ἡ laugh in a word" . insert-laugh-in-word))
(define-key clan-mode-map [menu-bar clan-menu final-particle]
    '("„ Tag or sentence final particle" . insert-final-particle))
(define-key clan-mode-map [menu-bar clan-menu vocative]
    '("‡ ‡ Vocative or summons" . insert-vocative))
(define-key clan-mode-map [menu-bar clan-menu diacritic]
    '("̣ Arabic dot diacritic" . insert-diacritic))
(define-key clan-mode-map [menu-bar clan-menu raised-h]
    '("ʰ Arabic raised h" . insert-raised-h))
(define-key clan-mode-map [menu-bar clan-menu stress]
    '("̄ Stress" . insert-stress))
(define-key clan-mode-map [menu-bar clan-menu glottal-stop]
    '("ʔ Glottal stopʔ" . insert-glottal-stop))
(define-key clan-mode-map [menu-bar clan-menu reverse-glottal]
    '("ʕ̌ Reverse glottalʕ̌" . insert-reverse-glottal))
(define-key clan-mode-map [menu-bar clan-menu caron]
    '("̌ Caron" . insert-caron))
(define-key clan-mode-map [menu-bar clan-menu raised-stroke]
    '("ˈ raisedˈ stroke" . insert-raised-stroke))
(define-key clan-mode-map [menu-bar clan-menu lowered-stroke]
    '("ˌ loweredˌ stroke" . insert-lowered-stroke))
(define-key clan-mode-map [menu-bar clan-menu length]
    '("ː length on the %pho line" . insert-length))
(define-key clan-mode-map [menu-bar clan-menu begin-phono-group]
    '("‹ ‹begin phono group› marker" . insert-begin-phono-group))
(define-key clan-mode-map [menu-bar clan-menu end-phono-group]
    '("› ‹end phono group› marker" . insert-end-phono-group))
(define-key clan-mode-map [menu-bar clan-menu begin-sign-group]
    '("〔 〔begin sign group〕" . insert-begin-sign-group))
(define-key clan-mode-map [menu-bar clan-menu end-sign-group]
    '("〕 〔end sign group〕" . insert-end-sign-group))
(define-key clan-mode-map [menu-bar clan-menu missing-word]
    '("… %pho missing word" . insert-pho-missing-word))
(define-key clan-mode-map [menu-bar clan-menu underline]
    '("̲ und̲e̲r̲line" . insert-underline))
(define-key clan-mode-map [menu-bar clan-menu open-quote]
    '("“ “open quote”" . insert-open-quote))
(define-key clan-mode-map [menu-bar clan-menu close-quote]
    '("” “close quote”" . insert-close-quote))


;;;###autoload
(define-derived-mode clan-mode text-mode "clan mode"
  "Major mode for editing CLAN type files (.cha)."

  (set (make-local-variable 'clan-mode-variant) t)

  (define-key-after
    clan-mode-map
    [menu-bar clan-menu]
    (cons "Clan-Mode" (make-sparse-keymap))
    'tools)

(local-set-key (kbd "<f1> <up>") 'insert-shift-high)
(local-set-key (kbd "<f1> <down>") 'insert-shift-low)
(local-set-key (kbd "<f1> 1") 'insert-rising-high)
(local-set-key (kbd "<f1> 2") 'insert-rising-mid)
(local-set-key (kbd "<f1> 3") 'insert-level)
(local-set-key (kbd "<f1> 4") 'insert-falling-mid)
(local-set-key (kbd "<f1> 5") 'insert-falling-low)
(local-set-key (kbd "<f1> 6") 'insert-unmarked-ending)
(local-set-key (kbd "<f1> +") 'insert-continuation)
(local-set-key (kbd "<f1> .") 'insert-inhalation)
(local-set-key (kbd "<f1> =") 'insert-latching)
(local-set-key (kbd "<f1> u") 'insert-uptake)
(local-set-key (kbd "<f1> [") 'insert-top-begin-overlap)
(local-set-key (kbd "<f1> ]") 'insert-top-end-overlap)
(local-set-key (kbd "<f1> {") 'insert-bottom-begin-overlap)
(local-set-key (kbd "<f1> }") 'insert-bottom-end-overlap)
(local-set-key (kbd "<f1> <right>") 'insert-faster)
(local-set-key (kbd "<f1> <left>") 'insert-slower)
(local-set-key (kbd "<f1> *") 'insert-creaky)
(local-set-key (kbd "<f1> /") 'insert-unsure)
(local-set-key (kbd "<f1> 0") 'insert-softer)
(local-set-key (kbd "<f1> )") 'insert-louder)
(local-set-key (kbd "<f1> d") 'insert-low-pitch)
(local-set-key (kbd "<f1> h") 'insert-high-pitch)
(local-set-key (kbd "<f1> l") 'insert-smile-voice)
(local-set-key (kbd "<f1> b") 'insert-breathy-voice)
(local-set-key (kbd "<f1> w") 'insert-whisper)
(local-set-key (kbd "<f1> y") 'insert-yawn)
(local-set-key (kbd "<f1> s") 'insert-singing)
(local-set-key (kbd "<f1> p") 'insert-precise)
(local-set-key (kbd "<f1> n") 'insert-constriction)
(local-set-key (kbd "<f1> r") 'insert-pitch-reset)
(local-set-key (kbd "<f1> c") 'insert-laugh-in-word)
(local-set-key (kbd "<f2> t") 'insert-final-particle)
(local-set-key (kbd "<f2> v") 'insert-vocative)
(local-set-key (kbd "<f2> ,") 'insert-diacritic)
(local-set-key (kbd "<f2> H") 'insert-raised-h)
(local-set-key (kbd "<f2> -") 'insert-stress)
(local-set-key (kbd "<f2> q") 'insert-glottal-stop)
(local-set-key (kbd "<f2> Q") 'insert-reverse-glottal)
(local-set-key (kbd "<f2> ;") 'insert-caron)
(local-set-key (kbd "<f2> 1") 'insert-raised-stroke)
(local-set-key (kbd "<f2> 2") 'insert-lowered-stroke)
(local-set-key (kbd "<f2> :") 'insert-length)
(local-set-key (kbd "<f2> <") 'insert-begin-phono-group)
(local-set-key (kbd "<f2> >") 'insert-end-phono-group)
(local-set-key (kbd "<f2> {") 'insert-begin-sign-group)
(local-set-key (kbd "<f2> }") 'insert-end-sign-group)
(local-set-key (kbd "<f2> m") 'insert-pho-missing-word)
(local-set-key (kbd "<f2> _") 'insert-underline)
(local-set-key (kbd "<f2> '") 'insert-open-quote)
(local-set-key (kbd "<f2> \"") 'insert-close-quote)

  
  (local-set-key (kbd "C-c l") 'playline)
  (local-set-key (kbd "C-c o") 'insert-bullet)
  (local-set-key (kbd "C-c p") 'play-from-line)
  (local-set-key (kbd "C-c s") 'stop-player)

  ;; code for keymap
  ;; code for syntax highlighting
  (setq font-lock-defaults '((clan-font-lock-keywords))))

;; add the mode to the `features' list
(provide 'clan-mode)

;;; clan-mode.el ends here
