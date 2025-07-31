
import { useEffect, useState } from 'react';

export const useScrollEffect = (elementRef: React.RefObject<HTMLElement>) => {
  const [scrollProgress, setScrollProgress] = useState(0);

  useEffect(() => {
    const handleScroll = () => {
      if (!elementRef.current) return;

      const element = elementRef.current;
      const rect = element.getBoundingClientRect();
      const windowHeight = window.innerHeight;
      
      // Calculate when element enters viewport
      const elementTop = rect.top;
      const elementBottom = rect.bottom;
      const elementHeight = rect.height;
      
      // Start progress when bottom of element first enters viewport
      // Complete progress when element is fully visible and starts to exit
      const enterPoint = windowHeight; // When bottom of element hits bottom of viewport
      const exitPoint = windowHeight * 0.3; // When element is well into viewport
      
      // Calculate progress based on element position
      let progress = 0;
      if (elementBottom >= 0 && elementTop <= windowHeight) {
        // Element is visible in viewport
        if (elementTop <= exitPoint) {
          progress = Math.min(1, (enterPoint - elementTop) / (enterPoint - exitPoint));
        }
      }
      
      setScrollProgress(Math.max(0, Math.min(1, progress)));
    };

    window.addEventListener('scroll', handleScroll);
    handleScroll(); // Initial call
    
    return () => window.removeEventListener('scroll', handleScroll);
  }, [elementRef]);

  return scrollProgress;
};
