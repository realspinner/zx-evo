#pragma once

namespace vdac2
{
  bool process_line();
  void set_ss(bool);
  u8 transfer(u8);
  bool open_ft8xx();
  void close_ft8xx();
  void ft8xx_tread(void *);
  void ft8xx_setup();
  void ft8xx_loop();
}
