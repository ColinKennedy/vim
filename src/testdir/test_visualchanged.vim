" Test VisualChanged

source check.vim
source shared.vim

" TODO: Add docstrings

let g:visual_changed = 0

func s:assert_count(value)
  call assert_equal(value, g:_visual_count)
endfunc

func s:make_test_buffer()
  call append(0, ["Hello", "Hello", "Hello"])

  return bufnr()
endfunc

func s:reset_buffers()
  %bwipeout!
  autocmd! VisualChanged
  let g:visual_changed = 0
endfunc

func s:watch_visualchanged()
  au VisualChanged * let g:_visual_count += 1
endfunc

func Test_change_visual_mode_runs_visualchanged()
  call s:reset_buffers()
  call s:watch_visualchanged()

  call s:make_test_buffer()

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

func Test_gv_runs_visualchanged()
  call s:reset_buffers()
  call s:watch_visualchanged()

  " TODO: Finish

  normal vjl
  call s:assert_count(3)

  normal <esc>Ggv
  call s:assert_count(4)
endfunc

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

func Test_visual_mode_o_does_not_trigger_visualchanged()
  call s:reset_buffers()
  call s:watch_visualchanged()

  call s:make_test_bufer()
  " TODO: Finish
endfunc

func Test_vblock_mode_o_does_not_trigger_visualchanged()
  call s:reset_buffers()
  call s:watch_visualchanged()

  " TODO: Finish
endfunc

func Test_vblock_mode_hl_does_not_trigger_visualchanged()
  call s:reset_buffers()
  call s:watch_visualchanged()

  " TODO: Finish
endfunc

func Test_vline_mode_o_does_not_trigger_visualchanged()
  call s:reset_buffers()
  call s:watch_visualchanged()

  " TODO: Finish
endfunc

call Test_runs_when_visual_mode_starts()
