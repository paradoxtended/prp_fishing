import React, { useEffect, useRef, useState } from 'react';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import type { MinigameProps } from '../../typings/minigame';
import './index.css'
import { fetchNui } from '../../utils/fetchNui';

// DO NOT TOUCH, UNLESS YOU KNOW WHAT YOU ARE DOING
const radius = 100;
const fishSize = 30;

const center = { x: radius, y: radius };

let currentPos = { x: center.x, y: center.y };
let targetPos = getRandomPositionInCircle();
let progress = 0;

let mouseX = 0;
let mouseY = 0;
let startTime = Date.now();

// --- HELPER FUNCTIONS ---

// Return a random position within the circle
function getRandomPositionInCircle() {
    const angle = Math.random() * 2 * Math.PI;
    const distance = Math.random() * (radius - fishSize / 2);
    return {
        x: center.x + distance * Math.cos(angle),
        y: center.y + distance * Math.sin(angle),
    };
};

// Format milliseconds into MM:SS string
function formatTime(ms: number) {
    const totalSeconds = Math.ceil(ms / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
};

// Update the circular progress ring's conic gradient
function updateCircularProgress(parent: HTMLElement, value: number) {
    const angle = (value / 100) * 360;
    parent.style.background = `conic-gradient(#84cc16 ${angle}deg, transparent 0deg)`;
};

const FishingMinigame: React.FC = () => {
    const dataRef = useRef<MinigameProps[]>(null);
    const dataIndexRef = useRef<number>(0);
    const [visible, setVisible] = useState(false);
    const [minigame, setMinigame] = useState<MinigameProps>({
        duration: 30000,
        speed: 0.015,
        progress: { add: 0.05, remove: 0.05 }
    });

    // Handle end of game (timeout / win or next level)
    function handleEnd(completed: boolean) {
        const container = document.querySelector('.container-wrapper-minigame');
        if (!container) return;

        const data = dataRef.current;
        if (!data || data.length === 0) return;

        const isLast = dataIndexRef.current + 1 === data.length;

        if (isLast || !completed) {
            // @ts-expect-error
            container.style.animation = 'slideOut-minigame 500ms forwards';
            setTimeout(() => setVisible(false), 500);
            fetchNui('catchFish', completed);
            return;
        }

        dataIndexRef.current += 1;
        const next = data[dataIndexRef.current];

        if (next) {
            setMinigame(next);
        } else {
            fetchNui('catchFish', false);
        }
    };

    useEffect(() => {
        const handleMouseMove = (e: MouseEvent) => {
            mouseX = e.clientX;
            mouseY = e.clientY;
        };

        document.addEventListener('mousemove', handleMouseMove);
        return () => document.removeEventListener('mousemove', handleMouseMove);
    }, []);

    useEffect(() => {
        if (visible) {
            progress = 0; // reset progress
            currentPos = { x: center.x, y: center.y };
            targetPos = getRandomPositionInCircle();
            startTime = Date.now();
            requestAnimationFrame(updateGame);
        }
    }, [visible, dataIndexRef.current]);

    useNuiEvent<MinigameProps | MinigameProps[]>('fishingMinigame', async (data) => {
        dataRef.current = Array.isArray(data) ? data : [data];
        dataIndexRef.current = 0;

        if (visible) {
            setVisible(false);
            await new Promise((resolve) => setTimeout(resolve, 100));
        };

        setMinigame(dataRef.current[dataIndexRef.current]);
        setVisible(true);
    });

    // --- MAIN GAME LOOP ---

    function updateGame() {
        // Move fish toward the target position
        currentPos.x += (targetPos.x - currentPos.x) * (minigame?.speed || 0.02);
        currentPos.y += (targetPos.y - currentPos.y) * (minigame?.speed || 0.02);

        // Flip fish direction based on movement
        const fish = document.getElementById('fish-minigame') as HTMLElement;
        const ring = document.querySelector('.circular-progress-ring-minigame') as HTMLElement;
        const timerDisplay = document.getElementById('timer-minigame') as HTMLElement;
        
        if (fish === null || ring === null || timerDisplay === null) return;

        fish.style.transform = targetPos.x < currentPos.x ? 'rotateY(180deg)' : 'rotateY(0)';

        // Position fish element on screen
        fish.style.left = `${currentPos.x - fishSize / 2}px`;
        fish.style.top = `${currentPos.y - fishSize / 2}px`;

        // If fish is close to target, choose a new random target
        if (Math.hypot(targetPos.x - currentPos.x, targetPos.y - currentPos.y) < 2) {
            targetPos = getRandomPositionInCircle();
        }

        // Calculate fish center and mouse distance
        const fishRect = fish.getBoundingClientRect();
        const fishCenterX = fishRect.left + fishRect.width / 2;
        const fishCenterY = fishRect.top + fishRect.height / 2;
        const distance = Math.hypot(mouseX - fishCenterX, mouseY - fishCenterY);

        // Update progress when mouse is near the fish
        if (distance < 10 && progress < 100) {
            progress += (minigame?.progress?.add || 0.05);
        } else if (distance >= 10 && progress > 0) {
            progress -= (minigame?.progress?.remove || 0.05);
        };

        progress = Math.min(100, Math.max(0, progress));
        updateCircularProgress(ring, progress);

        // Update timer display
        const elapsed = Date.now() - startTime;
        const remaining = Math.max(0, (minigame?.duration || 30000) - elapsed);
        timerDisplay.textContent = formatTime(remaining);

        // End game if time is up or progress is full
        if (progress >= 100 || elapsed >= (minigame?.duration || 30000)) {
            handleEnd(progress >= 100);
            return;
        }

        // Continue the game loop
        requestAnimationFrame(updateGame);
    };

    return (
        visible && (
            <div className="container-wrapper-minigame">
                <div id="timer-minigame"></div>
                <div className="circular-progress-ring-minigame"></div>

                <div className="container-minigame" id="circle">
                    <div id="fish-minigame"></div>
                </div>
            </div>
        )
    );
};

export default FishingMinigame