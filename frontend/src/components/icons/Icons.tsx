import React from 'react';

/**
 * Небольшой набор SVG-иконок.
 * react-icons не используется: его типы конфликтуют с TypeScript 4.9 + @types/react 19.
 */
type IconProps = React.SVGProps<SVGSVGElement>;

const strokeProps = {
  width: '1em',
  height: '1em',
  viewBox: '0 0 24 24',
  fill: 'none',
  stroke: 'currentColor',
  strokeWidth: 2,
  strokeLinecap: 'round' as const,
  strokeLinejoin: 'round' as const,
};

export const ArrowLeftIcon = (props: IconProps) => (
  <svg {...strokeProps} {...props}>
    <path d="M19 12H5M12 19l-7-7 7-7" />
  </svg>
);

export const ArrowRightIcon = (props: IconProps) => (
  <svg {...strokeProps} {...props}>
    <path d="M5 12h14M12 5l7 7-7 7" />
  </svg>
);

export const CloseIcon = (props: IconProps) => (
  <svg {...strokeProps} {...props}>
    <path d="M18 6 6 18M6 6l12 12" />
  </svg>
);

export const UserIcon = (props: IconProps) => (
  <svg {...strokeProps} {...props}>
    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
    <circle cx="12" cy="7" r="4" />
  </svg>
);

export const StarIcon = (props: IconProps) => (
  <svg width="1em" height="1em" viewBox="0 0 24 24" fill="currentColor" {...props}>
    <path d="M12 2.5l2.94 5.96 6.56.95-4.75 4.63 1.12 6.54L12 17.5l-5.87 3.08 1.12-6.54L2.5 9.41l6.56-.95L12 2.5z" />
  </svg>
);
