import numpy
from numpy import random

class Blackjack:
    def __init__(self):
        self.playercard_one = random.randint(1,13)
        self.playercard_two = random.randint(1,13)

        self.hit_card = random.randint(1,13)

        self.dealercard_one = random.randint(1,13)
        self.dealercard_two = random.randint(1,13)

        self.playerinitialhand = self.playercard_one + self.playercard_two
        self.dealerinitialhand = self.dealercard_one + self.dealercard_two

        print("Dealers initial hand", self.dealerinitialhand)
        print("You were dealt", self.playerinitialhand)

    def hit(self):
        self.player_hit = input("Hit(Yes/No)")
        if self.player_hit.lower() == "yes":
            self.playerfinalhand = self.playerinitialhand + self.hit_card
            print("Your final hand: ", self.playerfinalhand)
        else:
            self.playerfinalhand = self.playerinitialhand
            print("You stuck with your hand of: ", self.playerfinalhand)

    def dealerhit(self):
        while self.dealerinitialhand < 17:
            self.dealer_hit = random.randint(1,13)
            self.dealerinitialhand += self.dealer_hit

    def determinewinner(self):
        if self.playerfinalhand > 21:
            print("You went over 21, better luck next time!")
        elif self.dealerinitialhand > 21:
            print("Dealer went over 21! You win!")
        elif self.dealerinitialhand == 21:
            print("Dealer hit 21, YOU LOSE!")
        elif self.playerfinalhand == 21:
            print("You hit 21, YOU WIN!")
        elif self.playerfinalhand < 21 and self.playerfinalhand > self.dealerinitialhand:
            print("You win! Player hand: ", self.playerfinalhand, "Dealer hand: ",self.dealerinitialhand)
        elif self.dealerinitialhand < 21 and self.dealerinitialhand > self.playerfinalhand:
            print("You Lose, Dealer hand:",self.dealerinitialhand,"Player hand:",self.playerfinalhand)
        else:
            print("DRAW!")
def main():
    game = Blackjack()
    game.hit()
    game.dealerhit()
    game.determinewinner()

if __name__ == "__main__":
        main()