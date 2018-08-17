import UIKit

public extension UIColor
{
  public final var redValue: CGFloat { return rgba().r }
  public final var greenValue: CGFloat { return rgba().g }
  public final var blueValue: CGFloat { return rgba().b }
  public final var alphaValue: CGFloat { return rgba().a }
  
  private final func rgba() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)
  {
    guard let components: [CGFloat] = cgColor.components else { return (0, 0, 0, 0) }
    let numberOfComponents: Int = cgColor.numberOfComponents
    switch numberOfComponents {
    case 4:
      return (components[0], components[1], components[2], components[3])
    case 2:
      return (components[0], components[0], components[0], components[1])
    default:
      return (0, 0, 0, 1)
    }
  }
}
