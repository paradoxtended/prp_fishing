import { createRoot } from 'react-dom/client'
import { DndProvider } from 'react-dnd';
import { TouchBackend } from 'react-dnd-touch-backend';
import './index.css'
import App from './App.tsx'
import { isEnvBrowser } from './utils/misc';
import LocaleProvider from './providers/LocaleProvider.tsx';

if (isEnvBrowser()) {
  const root = document.getElementById('root');

  // https://i.imgur.com/iPTAdYV.png - Night time img
  root!.style.backgroundImage = 'url("https://i.imgur.com/3pzRj9n.png")';
  root!.style.backgroundSize = 'cover';
  root!.style.backgroundRepeat = 'no-repeat';
  root!.style.backgroundPosition = 'center';
}

const root = document.getElementById('root');

createRoot(root!).render(
  <DndProvider backend={TouchBackend} options={{ enableMouseEvents: true }}>
    <LocaleProvider>
      <App />
    </LocaleProvider>
  </DndProvider>
)