import copy
from collections import defaultdict

import dice_game
import pprint


class MDPSolve:
    def __init__(self, game=dice_game.DiceGame(), gamma=1.0):
        self.values = defaultdict(lambda: 0)
        self.best_actions = {}
        self.actions = defaultdict(lambda: defaultdict(lambda: 0))
        self.game = game
        self.gamma = gamma

    def solve(self, theta=0.001):
        delta = 1
        loops = 0

        while delta >= theta:
            delta = 0
            loops += 1
            new_values = self.values.copy()
            for state in self.game.states:
                temp = self.values[state]

                max_action = None
                max_action_value = float("-inf")

                for action in self.game.actions:
                    new_states, game_over, reward, probabilities = self.game.get_next_states(action, state)
                    if game_over:
                        value = reward
                    else:
                        value = 0
                        for new_state, probability in zip(new_states, probabilities):
                            value += probability*(reward + self.gamma*self.values[tuple(new_state)])

                    self.actions[state][action] = value
                    if value > max_action_value:
                        max_action = [action]
                        max_action_value = value
                    elif value == max_action_value:
                        max_action.append(action)

                new_values[state] = max_action_value
                self.best_actions[state] = max_action
                delta = max(delta, abs(temp - max_action_value))
            self.values = new_values
        # print(f"{loops} loops")


def solve(game, theta=0.001):
    solver = MDPSolve(game=game)
    solver.solve(theta)
    return {state: actions[0] for state, actions in solver.best_actions.items()}


if __name__ == "__main__":
    print(solve())
