import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';

const App = () => (
  <div className="app">
    <header className="app-header">
      <h1>Bienvenido a la Aplicación de Personas</h1>
      <p>La aplicación se está cargando correctamente.</p>
      <p>URL de la API: {process.env.REACT_APP_API_URL || 'No configurada'}</p>
    </header>
  </div>
);

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
