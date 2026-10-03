import { writable } from 'svelte/store';

function createToastStore() {
  const { subscribe, update } = writable([]);

  let nextId = 1;

  function show(message, type = 'info', duration = 3000) {
    const id = nextId++;
    const toast = { id, message, type };

    update(toasts => [...toasts, toast]);

    if (duration > 0) {
      setTimeout(() => {
        dismiss(id);
      }, duration);
    }

    return id;
  }

  function dismiss(id) {
    update(toasts => toasts.filter(t => t.id !== id));
  }

  return {
    subscribe,
    show,
    success: (msg, dur) => show(msg, 'success', dur),
    error: (msg, dur) => show(msg, 'error', dur),
    info: (msg, dur) => show(msg, 'info', dur),
    dismiss
  };
}

export const toast = createToastStore();
