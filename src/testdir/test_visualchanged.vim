" Test VisualChanged

source check.vim
source shared.vim

let g:visual_changed = 0

func s:assert_count(value)
  call assert_equal(a:value, g:visual_changed)
endfunc

" Set the buffer up for further tests.
func s:initialize_test_buffer()
  call append(0, ["Hello", "Hello", "Hello"])

  return bufnr()
endfunc

" Remove all buffers and reset all VisualChanged counts.
func s:reset_buffers()
  %bwipeout!
  autocmd! VisualChanged
  let g:visual_changed = 0
endfunc

" Keep track of whenever VisualChanged is called.
func s:watch_visualchanged()
  au VisualChanged * let g:visual_changed += 1
endfunc

" If the user changes modes, call VisualChanged only if the bounds change.
"
" For example `v` -> `C-v` changes visual mode but the actual bounding box of
" the visual selection has not changed. So VisualChanged does not run.
"
func Test_change_visual_mode_runs_visualchanged()
  call s:reset_buffers()
  call s:watch_visualchanged()

  call s:initialize_test_buffer()

  normal v
  call s:assert_count(1)

  normal V
  call s:assert_count(2)

  normal <c-v>
  call s:assert_count(3)

  normal v
  call s:assert_count(4)

  " IMPORTANT: When only one cell is selected in VISUAL (v) mode, switching to
  " V-BLOCK (<c-v>) mode doesn't actually change the visual region. So the
  " VisualChanged autocmd does not run.
  normal <c-v>
  call s:assert_count(4)
endfunc

" Selecting the previous visual selection will trigger VisualChanged.
func Test_gv_runs_visualchanged()
  call s:reset_buffers()
  call s:watch_visualchanged()

  normal vjl
  call s:assert_count(3)

  normal <esc>Ggv
  call s:assert_count(4)
endfunc

" Trigger VisualChanged When the bounds of a visual selection changes.
func Test_runs_when_visual_area_changes()
  call s:reset_buffers()
  call s:watch_visualchanged()

  " TODO: Finish

  normal v
  call s:assert_count(1)

  normal iw
  call s:assert_count(2)

  normal Vj0
  call s:assert_count(5)

  normal <esc>Vjl
  call s:assert_count(8)

  normal <esc>gg<c-v>ejh
  call s:assert_count(12)
endfunc

" Trigger VisualChanged when changing from a non-visual mode (e.g. normal mode).
func Test_runs_when_visual_mode_starts()
  call s:reset_buffers()
  call s:watch_visualchanged()

  " TODO: Finish

  normal v
  call s:assert_count(1)

  normal iw
  call s:assert_count(2)

  normal V
  call s:assert_count(3)

  normal <c-v>
  call s:assert_count(4)

  normal v
  call s:assert_count(5)

  normal <esc>v
  call s:assert_count(6)

  normal <esc>V
  call s:assert_count(7)

  normal <esc><c-v>
  call s:assert_count(8)
endfunc

" Swapping corners of a visual selection's 'bounds does not trigger VisualChanged.
func Test_visual_mode_o_does_not_trigger_visualchanged()
  call s:reset_buffers()
  call s:watch_visualchanged()

  call s:make_test_bufer()
  " TODO: Finish
endfunc

" Swapping corners of a visual selection's 'bounds does not trigger VisualChanged.
func Test_vblock_mode_o_does_not_trigger_visualchanged()
  call s:reset_buffers()
  call s:watch_visualchanged()

  " TODO: Finish
endfunc

" Don't trigger VisualChanged if the cursor moves left/right in Visual-block mode.
func Test_vline_mode_o_does_not_trigger_visualchanged()
  call s:reset_buffers()
  call s:watch_visualchanged()

  " TODO: Finish
endfunc
