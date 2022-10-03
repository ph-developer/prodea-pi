enum Breakpoint {
  xs(0),
  sm(576),
  md(768),
  lg(992),
  xl(1200),
  xxl(1400);

  final int minDimension;

  const Breakpoint(this.minDimension);
}
