import { describe, it, expect } from 'vitest';
import { name } from './index';

describe('@tt3dato/core stub', () => {
  it('exports package name', () => {
    expect(name).toBe('@tt3dato/core');
  });
});
