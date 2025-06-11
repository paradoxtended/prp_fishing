import React, { type RefObject, useRef } from 'react';
import { type DragLayerMonitor, useDragLayer, type XYCoord } from 'react-dnd';
import { getColor } from '../Shop';

const subtract = (a: XYCoord, b: XYCoord): XYCoord => {
  return {
    x: a.x - b.x,
    y: a.y - b.y,
  };
};

const calculateParentOffset = (monitor: DragLayerMonitor): XYCoord => {
  const client = monitor.getInitialClientOffset();
  const source = monitor.getInitialSourceClientOffset();
  if (client === null || source === null || client.x === undefined || client.y === undefined) {
    return { x: 0, y: 0 };
  }
  return subtract(client, source);
};

export const calculatePointerPosition = (monitor: DragLayerMonitor, childRef: RefObject<Element>): XYCoord | null => {
  const offset = monitor.getClientOffset();
  if (offset === null) {
    return null;
  }

  if (!childRef.current || !childRef.current.getBoundingClientRect) {
    return subtract(offset, calculateParentOffset(monitor));
  }

  const bb = childRef.current.getBoundingClientRect();
  const middle = { x: bb.width / 2, y: bb.height / 2 };
  return subtract(offset, middle);
};

const DragPreview: React.FC = () => {
  const element = useRef<HTMLDivElement>(null);

  const { data, isDragging, currentOffset } = useDragLayer((monitor) => ({
    data: monitor.getItem(),
    // @ts-expect-error
    currentOffset: calculatePointerPosition(monitor, element),
    isDragging: monitor.isDragging(),
  }));

  const color = getColor(data?.rarity || 'common');

  return (
    <>
      {isDragging && currentOffset && data.imageUrl && (
        <div
          className="item-drag-preview"
          ref={element}
          style={{
            transform: `translate(${currentOffset.x}px, ${currentOffset.y}px)`,
          }}
        >
            <div 
            className="card"
            style={{
                background: color.background,
                color: color.text,
                borderBottom: `3px solid ${color.text}`,
                '--borderColor': color.text,
                opacity: isDragging ? 0.5 : 1,
                cursor: 'pointer',
            } as React.CSSProperties }
            >
                <p className="rarity" style={{ color: data.rarity == 'common' ? '#ffffff' : '' }}>{data.rarity?.toUpperCase() || 'COMMON'}</p>
                <img src={data.imageUrl} />
                <div className="card-bottom">
                    <p className="label">{data.label}</p>
                    <p className="price">${data.price.toLocaleString('en-US')}</p>
                </div>
            </div>
        </div>
      )}
    </>
  );
};

export default DragPreview;